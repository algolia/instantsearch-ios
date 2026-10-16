//
//  Copyright (c) 2014 - 2017 Tuomas Artman. All rights reserved.
//

import Foundation
#if os(Linux)
  import Dispatch
#endif

/// A SignalLister represenents an instance and its association with a `Signal`.
///
/// `SignalSubscription` is thread-safe: its configuration (`filter`, `sample`, `onQueue`, `once`) can be set while
/// the `Signal` is being fired from another thread.
public final class SignalSubscription<T> {
  public typealias ParameterType = T
  public typealias SignalCallback = (T) -> Void
  public typealias SignalFilter = (T) -> Bool

  // The observer.
  public var observer: AnyObject? {
    get {
      return synchronized(lock) { _ in _observer }
    }
    set {
      synchronized(lock) { _ in _observer = newValue }
    }
  }

  /// Whether the observer should be removed once it observes the `Signal` firing once. Defaults to false.
  public var once: Bool {
    get {
      return synchronized(lock) { _ in _once }
    }
    set {
      synchronized(lock) { _ in _once = newValue }
    }
  }

  /// Lock guarding the configuration and the dispatch state of the subscription.
  /// Must never be held while invoking the filter or the callback.
  private let lock = NSLock()
  private weak var _observer: AnyObject?
  private var _once = false
  private var filter: SignalFilter?
  private var dispatchQueue: DispatchQueue?
  private var sampleInterval: TimeInterval?
  /// The latest data received during the current sampling interval
  private var sampledData: T?
  /// Whether the past data is being replayed to the observer. The data fired meanwhile is held back.
  private var isReplaying = false
  /// The data fired while the past data was being replayed, delivered in order once the replay completes
  private var heldBackData: [T] = []
  let callback: SignalCallback

  init<O: AnyObject>(observer: O, callback: @escaping (O, T) -> Void) {
    _observer = observer
    self.callback = { [weak observer] value in
      guard let observer = observer else { return }
      callback(observer, value)
    }
  }

  /// Assigns a filter to the `SignalSubscription`. This lets you define conditions under which a observer should actually
  /// receive the firing of a `Singal`. The closure that is passed an argument can decide whether the firing of a
  /// `Signal` should actually be dispatched to its observer depending on the data fired.
  ///
  /// If the closeure returns true, the observer is informed of the fire. The default implementation always
  /// returns `true`.
  ///
  /// - parameter predicate: A closure that can decide whether the `Signal` fire should be dispatched to its observer.
  /// - returns: Returns self so you can chain calls.
  @discardableResult
  public func filter(_ predicate: @escaping SignalFilter) -> SignalSubscription {
    synchronized(lock) { graveyard in
      if let displacedFilter = filter {
        graveyard.append(displacedFilter)
      }
      filter = predicate
    }
    return self
  }

  /// Tells the observer to sample received `Signal` data and only dispatch the latest data once the time interval
  /// has elapsed. This is useful if the subscriber wants to throttle the amount of data it receives from the
  /// `Signal`.
  ///
  /// - parameter sampleInterval: The number of seconds to delay dispatch.
  /// - returns: Returns self so you can chain calls.
  @discardableResult
  public func sample(every sampleInterval: TimeInterval) -> SignalSubscription {
    synchronized(lock) { _ in self.sampleInterval = sampleInterval }
    return self
  }

  /// Assigns a dispatch queue to the `SignalSubscription`. The queue is used for scheduling the observer calls. If not
  /// nil, the callback is fired asynchronously on the specified queue. Otherwise, the block is run synchronously
  /// on the posting thread, which is its default behaviour.
  ///
  /// - parameter queue: A queue for performing the observer's calls.
  /// - returns: Returns self so you can chain calls.
  @discardableResult
  public func onQueue(_ queue: DispatchQueue) -> SignalSubscription {
    synchronized(lock) { _ in dispatchQueue = queue }
    return self
  }

  /// Cancels the observer. This will cancelSubscription the listening object from the `Signal`.
  public func cancel() {
    synchronized(lock) { _ in _observer = nil }
  }

  // MARK: - Internal Interface

  /// Dispatches the fired data to the observer, unless it is filtered out.
  ///
  /// - returns: whether the subscription is still active
  func dispatch(data: T) -> Bool {
    let (filter, isActive): (SignalFilter?, Bool) = synchronized(lock) { _ in (self.filter, _observer != nil) }
    guard isActive else {
      return false
    }
    // The filter is user code: it is evaluated outside of the lock
    if let filter = filter, !filter(data) {
      return synchronized(lock) { _ in _observer != nil }
    }
    deliver(data)
    return synchronized(lock) { _ in _observer != nil }
  }

  /// Starts holding back the fired data until the past data has been replayed.
  func beginReplay() {
    synchronized(lock) { _ in isReplaying = true }
  }

  /// Replays the past data to the observer, then delivers the data fired in the meantime, in order.
  ///
  /// The data keeps being held back until nothing is left to deliver, so that a concurrent fire cannot overtake
  /// the held back data: the subscription goes live only once it has caught up.
  func replay(_ pastData: T) {
    callback(pastData)
    while true {
      let heldBackData: [T] = synchronized(lock) { _ in
        if self.heldBackData.isEmpty {
          isReplaying = false
          return []
        }
        defer { self.heldBackData.removeAll() }
        return self.heldBackData
      }
      guard !heldBackData.isEmpty else {
        return
      }
      for data in heldBackData {
        deliver(data, heldBack: true)
      }
    }
  }

  // MARK: - Delivery

  private enum Delivery {
    /// The data is not delivered: the subscription is inactive, the data is held back or sampled
    case none
    /// The data is delivered immediately, asynchronously if a queue is set
    case immediate(queue: DispatchQueue?)
    /// The latest sampled data is delivered once the sampling interval has elapsed
    case scheduledSample(queue: DispatchQueue?, interval: TimeInterval)
  }

  /// Delivers the data which passed the filter, honoring the one-shot, replay and sampling configurations.
  ///
  /// - parameter heldBack: whether the data was held back during the replay and is now being delivered by it
  private func deliver(_ data: T, heldBack: Bool = false) {
    // Decide atomically what to do with the data so that concurrent fires cannot deliver a one-shot subscription
    // twice, nor overtake the replay of the past data
    let delivery: Delivery = synchronized(lock) { graveyard in
      decideDeliveryLocked(of: data, heldBack: heldBack, graveyard: &graveyard)
    }
    perform(delivery, of: data)
  }

  /// Must be called while holding the lock.
  private func decideDeliveryLocked(of data: T, heldBack: Bool, graveyard: inout [Any]) -> Delivery {
    guard _observer != nil else {
      return .none
    }
    if isReplaying, !heldBack {
      heldBackData.append(data)
      return .none
    }
    if _once {
      _observer = nil
    }
    guard let sampleInterval = sampleInterval else {
      return .immediate(queue: dispatchQueue)
    }
    let shouldSchedule = sampledData == nil
    if let displacedData = sampledData {
      graveyard.append(displacedData)
    }
    sampledData = data
    return shouldSchedule ? .scheduledSample(queue: dispatchQueue, interval: sampleInterval) : .none
  }

  private func perform(_ delivery: Delivery, of data: T) {
    switch delivery {
    case .none:
      break
    case let .immediate(queue):
      if let queue = queue {
        queue.async { [weak self] in
          self?.callback(data)
        }
      } else {
        callback(data)
      }
    case let .scheduledSample(queue, interval):
      let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(interval * 1000))
      (queue ?? DispatchQueue.main).asyncAfter(deadline: deadline) { [weak self] in
        guard let definiteSelf = self else { return }
        let sampledData: T? = synchronized(definiteSelf.lock) { _ in
          defer { definiteSelf.sampledData = nil }
          return definiteSelf.sampledData
        }
        if let sampledData = sampledData {
          definiteSelf.callback(sampledData)
        }
      }
    }
  }
}

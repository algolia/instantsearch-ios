//
//  Copyright (c) 2014 - 2017 Tuomas Artman. All rights reserved.
//

import Foundation
#if os(Linux)
  import Dispatch
#endif

/// Create instances of `Signal` and assign them to public constants on your class for each event type that your
/// class fires.
///
/// `Signal` is thread-safe: it can be fired and subscribed to from any thread. Its mutable state is guarded by a
/// lock which is never held while invoking the subscribers callbacks, so a callback can safely subscribe to, cancel
/// a subscription of or fire the very same `Signal`.
public final class Signal<T> {
  public typealias SignalCallback<O: AnyObject> = (O, T) -> Void

  /// The number of times the `Signal` has fired.
  public var fireCount: Int {
    return synchronized { _fireCount }
  }

  /// Whether or not the `Signal` should retain a reference to the last data it was fired with. Defaults to false.
  public var retainLastData: Bool {
    get {
      return synchronized { _retainLastData }
    }
    set {
      synchronized {
        _retainLastData = newValue
        if !newValue {
          _lastDataFired = nil
        }
      }
    }
  }

  /// The last data that the `Signal` was fired with. In order for the `Signal` to retain the last fired data, its
  /// `retainLastFired`-property needs to be set to true
  public var lastDataFired: T? {
    return synchronized { _lastDataFired }
  }

  /// All the observers of to the `Signal`.
  public var observers: [AnyObject] {
    return synchronized {
      signalListeners.compactMap { $0.observer }
    }
  }

  /// Lock guarding the mutable state of the `Signal`.
  /// Must never be held while invoking a subscriber callback to avoid deadlocks on re-entrancy.
  private let lock = NSLock()
  private var _fireCount: Int = 0
  private var _retainLastData: Bool
  private var _lastDataFired: T?
  private var signalListeners = [SignalSubscription<T>]()

  /// Initializer.
  ///
  /// - parameter retainLastData: Whether or not the Signal should retain a reference to the last data it was fired
  ///   with. Defaults to false.
  public init(retainLastData: Bool = false) {
    _retainLastData = retainLastData
  }

  /// Subscribes an observer to the `Signal`.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  /// - returns: A `SignalSubscription` that can be used to cancel or filter the subscription.
  @discardableResult
  public func subscribe<O: AnyObject>(with observer: O, callback: @escaping SignalCallback<O>) -> SignalSubscription<T> {
    let signalListener = SignalSubscription<T>(observer: observer, callback: callback)
    _ = register(signalListener)
    return signalListener
  }

  /// Subscribes an observer to the `Signal`. The subscription is automatically canceled after the `Signal` has
  /// fired once.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke when the signal fires for the first time.
  @discardableResult
  public func subscribeOnce<O: AnyObject>(with observer: O, callback: @escaping SignalCallback<O>) -> SignalSubscription<T> {
    let signalListener = SignalSubscription<T>(observer: observer, callback: callback)
    // The flag is set before the registration so that a concurrent `fire` cannot deliver the data twice
    signalListener.once = true
    _ = register(signalListener)
    return signalListener
  }

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  @discardableResult
  public func subscribePast<O: AnyObject>(with observer: O, callback: @escaping SignalCallback<O>) -> SignalSubscription<T> {
    #if DEBUG
      signalsAssert(retainLastData, "can't subscribe to past events on Signal with retainLastData set to false")
    #endif
    let signalListener = SignalSubscription<T>(observer: observer, callback: callback)
    if let lastDataFired = register(signalListener) {
      signalListener.callback(lastDataFired)
    }
    return signalListener
  }

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true. If it has
  /// not been fired yet, it will continue listening until it fires for the first time.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the signal fires.
  @discardableResult
  public func subscribePastOnce<O: AnyObject>(with observer: O, callback: @escaping SignalCallback<O>) -> SignalSubscription<T> {
    #if DEBUG
      signalsAssert(retainLastData, "can't subscribe to past events on Signal with retainLastData set to false")
    #endif
    let signalListener = SignalSubscription<T>(observer: observer, callback: callback)
    let lastDataFired: T? = synchronized {
      flushCancelledListenersLocked()
      // If there is a past value, the subscription is fulfilled immediately and doesn't need to be registered
      guard _lastDataFired == nil else {
        return _lastDataFired
      }
      signalListener.once = true
      signalListeners.append(signalListener)
      return nil
    }
    if let lastDataFired = lastDataFired {
      signalListener.callback(lastDataFired)
      signalListener.cancel()
    }
    return signalListener
  }

  /// Fires the `Singal`.
  ///
  /// - parameter data: The data to fire the `Signal` with.
  public func fire(_ data: T) {
    // Update the state and snapshot the listeners under the lock, then dispatch outside of it
    let listeners: [SignalSubscription<T>] = synchronized {
      _fireCount += 1
      _lastDataFired = _retainLastData ? data : nil
      flushCancelledListenersLocked()
      return signalListeners
    }

    for signalListener in listeners where (signalListener.filter?(data)).isNil(or: true) {
      _ = signalListener.dispatch(data: data)
    }
  }

  /// Cancels all subscriptions for an observer.
  ///
  /// - parameter observer: The observer whose subscriptions to cancel
  public func cancelSubscription(for observer: AnyObject) {
    synchronized {
      signalListeners = signalListeners.filter {
        if let definiteListener: AnyObject = $0.observer {
          return definiteListener !== observer
        }
        return false
      }
    }
  }

  /// Cancels all subscriptions for the `Signal`.
  public func cancelAllSubscriptions() {
    synchronized {
      signalListeners.removeAll(keepingCapacity: false)
    }
  }

  /// Clears the last fired data from the `Signal` and resets the fire count.
  public func clearLastData() {
    synchronized {
      _lastDataFired = nil
    }
  }

  // MARK: - Private Interface

  private func synchronized<R>(_ body: () throws -> R) rethrows -> R {
    lock.lock()
    defer { lock.unlock() }
    return try body()
  }

  /// Registers the listener and returns the last fired data, atomically.
  private func register(_ signalListener: SignalSubscription<T>) -> T? {
    return synchronized {
      flushCancelledListenersLocked()
      signalListeners.append(signalListener)
      return _lastDataFired
    }
  }

  /// Must be called while holding the lock.
  private func flushCancelledListenersLocked() {
    guard signalListeners.contains(where: { $0.observer == nil }) else {
      return
    }
    signalListeners = signalListeners.filter {
      return $0.observer != nil
    }
  }
}

public extension Signal where T == Void {
  func fire() {
    fire(())
  }
}

/// A SignalLister represenents an instance and its association with a `Signal`.
public final class SignalSubscription<T> {
  public typealias ParameterType = T
  public typealias SignalCallback = (T) -> Void
  public typealias SignalFilter = (T) -> Bool

  // The observer.
  public weak var observer: AnyObject?

  /// Whether the observer should be removed once it observes the `Signal` firing once. Defaults to false.
  public var once = false

  /// Lock guarding the state mutated while dispatching (`observer` consumption of one-shot subscriptions and sampling).
  private let lock = NSLock()
  fileprivate var queuedData: T?
  fileprivate var filter: SignalFilter?
  fileprivate let callback: SignalCallback
  fileprivate var dispatchQueue: DispatchQueue?
  private var sampleInterval: TimeInterval?

  fileprivate init<O: AnyObject>(observer: O, callback: @escaping (O, T) -> Void) {
    self.observer = observer
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
    filter = predicate
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
    self.sampleInterval = sampleInterval
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
    dispatchQueue = queue
    return self
  }

  /// Cancels the observer. This will cancelSubscription the listening object from the `Signal`.
  public func cancel() {
    observer = nil
  }

  // MARK: - Internal Interface

  func dispatch(data: T) -> Bool {
    // Check the observer is still alive and, for one-shot subscriptions, consume the subscription atomically
    // so that concurrent fires cannot deliver the data twice
    let shouldDispatch: Bool = synchronized {
      guard observer != nil else {
        return false
      }
      if once {
        observer = nil
      }
      return true
    }

    guard shouldDispatch else {
      return false
    }

    if let sampleInterval = sampleInterval {
      let shouldSchedule: Bool = synchronized {
        defer { queuedData = data }
        return queuedData == nil
      }
      if shouldSchedule {
        let block = { [weak self] () in
          guard let definiteSelf = self else { return }
          let sampledData: T? = definiteSelf.synchronized {
            defer { definiteSelf.queuedData = nil }
            return definiteSelf.queuedData
          }
          if let sampledData = sampledData {
            definiteSelf.callback(sampledData)
          }
        }
        let dispatchQueue = self.dispatchQueue ?? DispatchQueue.main
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(sampleInterval * 1000))
        dispatchQueue.asyncAfter(deadline: deadline, execute: block)
      }
    } else {
      if let queue = dispatchQueue {
        queue.async { [weak self] in
          self?.callback(data)
        }
      } else {
        callback(data)
      }
    }

    return observer != nil
  }

  private func synchronized<R>(_ body: () throws -> R) rethrows -> R {
    lock.lock()
    defer { lock.unlock() }
    return try body()
  }
}

infix operator =>: AssignmentPrecedence

/// Helper operator to fire signal data.
public func => <T>(signal: Signal<T>, data: T) {
  signal.fire(data)
}

private func signalsAssert(_ condition: Bool, _ message: String) {
  #if DEBUG
    if let assertionHandlerOverride = assertionHandlerOverride {
      assertionHandlerOverride(condition, message)
      return
    }
  #endif
  assert(condition, message)
}

#if DEBUG
  var assertionHandlerOverride: ((_ condition: Bool, _ message: String) -> Void)?
#endif

extension Optional where Wrapped == Bool {
  func isNil(or expectedValue: Bool) -> Bool {
    switch self {
    case .none:
      return true
    case let .some(value):
      return value == expectedValue
    }
  }
}

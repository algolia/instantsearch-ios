//
//  Copyright (c) 2014 - 2017 Tuomas Artman. All rights reserved.
//

import Foundation
#if os(Linux)
import Dispatch
#endif

/// Create instances of `Signal` and assign them to public constants on your class for each event type that your
/// class fires.
final public class Signal<T> {

    public typealias SignalCallback<O: AnyObject> = (O, T) -> Void

    /// The number of times the `Signal` has fired.
    public private(set) var fireCount: Int = 0

    /// Whether or not the `Signal` should retain a reference to the last data it was fired with. Defaults to false.
    public var retainLastData: Bool = false {
        didSet {
            if !retainLastData {
                lastDataFired = nil
            }
        }
    }

    /// The last data that the `Signal` was fired with. In order for the `Signal` to retain the last fired data, its
    /// `retainLastFired`-property needs to be set to true
    public private(set) var lastDataFired: T?

    /// All the observers of to the `Signal`.
    public var observers: [AnyObject] {
        get {
            return signalListeners.filter {
                return $0.observer != nil
                }.map { signal -> AnyObject in
                    return signal.observer!
            }
        }
    }

    private var signalListeners = [SignalSubscription<T>]()

    /// Initializer.
    /// 
    /// - parameter retainLastData: Whether or not the Signal should retain a reference to the last data it was fired 
    ///   with. Defaults to false.
    public init(retainLastData: Bool = false) {
        self.retainLastData = retainLastData
    }

    /// Subscribes an observer to the `Signal`.
    ///
    /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
    ///   subscription is automatically cancelled.
    /// - parameter callback: The closure to invoke whenever the `Signal` fires.
    /// - returns: A `SignalSubscription` that can be used to cancel or filter the subscription.
    @discardableResult
  public func subscribe<O: AnyObject>(with observer: O, callback: @escaping SignalCallback<O>) -> SignalSubscription<T> {
        flushCancelledListeners()
        let signalListener = SignalSubscription<T>(observer: observer, callback: callback)
        signalListeners.append(signalListener)
        return signalListener
    }

    /// Subscribes an observer to the `Signal`. The subscription is automatically canceled after the `Signal` has
    /// fired once.
    ///
    /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
    ///   subscription is automatically cancelled.
    /// - parameter callback: The closure to invoke when the signal fires for the first time.
    @discardableResult
    public func subscribeOnce<O: AnyObject>(with observer: O, callback: @escaping  SignalCallback<O>) -> SignalSubscription<T> {
        let signalListener = self.subscribe(with: observer, callback: callback)
        signalListener.once = true
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
        let signalListener = self.subscribe(with: observer, callback: callback)
        if let lastDataFired = lastDataFired {
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
        let signalListener = self.subscribe(with: observer, callback: callback)
        if let lastDataFired = lastDataFired {
            signalListener.callback(lastDataFired)
            signalListener.cancel()
        } else {
            signalListener.once = true
        }
        return signalListener
    }

    /// Fires the `Singal`.
    ///
    /// - parameter data: The data to fire the `Signal` with.
    public func fire(_ data: T) {
        fireCount += 1
        lastDataFired = retainLastData ? data : nil
        flushCancelledListeners()

      for signalListener in signalListeners where (signalListener.filter?(data)).isNil(or: true) {
          _ = signalListener.dispatch(data: data)
        }
    }

    /// Cancels all subscriptions for an observer.
    ///
    /// - parameter observer: The observer whose subscriptions to cancel
    public func cancelSubscription(for observer: AnyObject) {
        signalListeners = signalListeners.filter {
            if let definiteListener: AnyObject = $0.observer {
                return definiteListener !== observer
            }
            return false
        }
    }

    /// Cancels all subscriptions for the `Signal`.
    public func cancelAllSubscriptions() {
        signalListeners.removeAll(keepingCapacity: false)
    }

    /// Clears the last fired data from the `Signal` and resets the fire count.
    public func clearLastData() {
        lastDataFired = nil
    }

    // MARK: - Private Interface

    private func flushCancelledListeners() {
        var removeListeners = false
        for signalListener in signalListeners where signalListener.observer == nil {
          removeListeners = true
        }
        if removeListeners {
            signalListeners = signalListeners.filter {
                return $0.observer != nil
            }
        }
    }
}

public extension Signal where T == Void {
    func fire() {
        fire(())
    }
}

/// A SignalLister represenents an instance and its association with a `Signal`.
final public class SignalSubscription<T> {

    public typealias ParameterType = T
    public typealias SignalCallback = (T) -> Void
    public typealias SignalFilter = (T) -> Bool

    // The observer.
    weak public var observer: AnyObject?

    /// Whether the observer should be removed once it observes the `Signal` firing once. Defaults to false.
    public var once = false

    fileprivate var queuedData: T?
    fileprivate var filter: (SignalFilter)?
    fileprivate var callback: SignalCallback
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
        self.filter = predicate
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
        self.dispatchQueue = queue
        return self
    }

    /// Cancels the observer. This will cancelSubscription the listening object from the `Signal`.
    public func cancel() {
        self.observer = nil
    }

    // MARK: - Internal Interface

    func dispatch(data: T) -> Bool {
        guard observer != nil else {
            return false
        }

        if once {
            observer = nil
        }

        if let sampleInterval = sampleInterval {
            if queuedData != nil {
                queuedData = data
            } else {
                queuedData = data
                let block = { [weak self] () -> Void in
                  if let definiteSelf = self {
                        let data = definiteSelf.queuedData!
                        definiteSelf.queuedData = nil
                        definiteSelf.callback(data)
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
}

infix operator => : AssignmentPrecedence

/// Helper operator to fire signal data.
public func =><T> (signal: Signal<T>, data: T) {
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
var assertionHandlerOverride:((_ condition: Bool, _ message: String) -> Void)?
#endif

extension Optional where Wrapped == Bool {

  func isNil(or expectedValue: Bool) -> Bool {
    switch self {
    case .none:
      return true
    case .some(let value):
      return value == expectedValue
    }
  }

}

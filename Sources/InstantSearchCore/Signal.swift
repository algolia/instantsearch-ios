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
/// a subscription of or fire the very same `Signal`. The objects displaced by a mutation (replaced retained data,
/// removed subscriptions) are released once the lock is released, so their deinitializers can re-enter the `Signal`
/// as well.
public final class Signal<T> {
  public typealias SignalCallback<O: AnyObject> = (O, T) -> Void

  /// The number of times the `Signal` has fired.
  public var fireCount: Int {
    return synchronized(lock) { _ in _fireCount }
  }

  /// Whether or not the `Signal` should retain a reference to the last data it was fired with. Defaults to false.
  public var retainLastData: Bool {
    get {
      return synchronized(lock) { _ in _retainLastData }
    }
    set {
      synchronized(lock) { graveyard in
        _retainLastData = newValue
        if !newValue, let displacedData = _lastDataFired {
          graveyard.append(displacedData)
          _lastDataFired = nil
        }
      }
    }
  }

  /// The last data that the `Signal` was fired with. In order for the `Signal` to retain the last fired data, its
  /// `retainLastFired`-property needs to be set to true
  public var lastDataFired: T? {
    return synchronized(lock) { _ in _lastDataFired }
  }

  /// All the observers of to the `Signal`.
  public var observers: [AnyObject] {
    return synchronized(lock) { _ in
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
    _ = register(signalListener, replayingPastData: false)
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
    _ = register(signalListener, replayingPastData: false)
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
    if let lastDataFired = register(signalListener, replayingPastData: true) {
      signalListener.replay(lastDataFired)
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
    let lastDataFired: T? = synchronized(lock) { graveyard in
      flushCancelledListenersLocked(&graveyard)
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
    let listeners: [SignalSubscription<T>] = synchronized(lock) { graveyard in
      _fireCount += 1
      if let displacedData = _lastDataFired {
        graveyard.append(displacedData)
      }
      _lastDataFired = _retainLastData ? data : nil
      flushCancelledListenersLocked(&graveyard)
      return signalListeners
    }

    for signalListener in listeners {
      _ = signalListener.dispatch(data: data)
    }
  }

  /// Cancels all subscriptions for an observer.
  ///
  /// - parameter observer: The observer whose subscriptions to cancel
  public func cancelSubscription(for observer: AnyObject) {
    synchronized(lock) { graveyard in
      var remainingListeners: [SignalSubscription<T>] = []
      for signalListener in signalListeners {
        if let definiteObserver: AnyObject = signalListener.observer, definiteObserver !== observer {
          remainingListeners.append(signalListener)
        } else {
          graveyard.append(signalListener)
        }
      }
      signalListeners = remainingListeners
    }
  }

  /// Cancels all subscriptions for the `Signal`.
  public func cancelAllSubscriptions() {
    synchronized(lock) { graveyard in
      graveyard.append(contentsOf: signalListeners)
      signalListeners.removeAll(keepingCapacity: false)
    }
  }

  /// Clears the last fired data from the `Signal` and resets the fire count.
  public func clearLastData() {
    synchronized(lock) { graveyard in
      if let displacedData = _lastDataFired {
        graveyard.append(displacedData)
      }
      _lastDataFired = nil
    }
  }

  // MARK: - Private Interface

  /// Registers the listener and returns the last fired data, atomically.
  ///
  /// When the past data is going to be replayed to the listener, the replay starts before the listener gets exposed
  /// to concurrent fires, so that the data fired in the meantime is held back until the replay completes.
  private func register(_ signalListener: SignalSubscription<T>, replayingPastData: Bool) -> T? {
    return synchronized(lock) { graveyard in
      flushCancelledListenersLocked(&graveyard)
      if replayingPastData, _lastDataFired != nil {
        signalListener.beginReplay()
      }
      signalListeners.append(signalListener)
      return _lastDataFired
    }
  }

  /// Removes the listeners whose observer has been deallocated. Must be called while holding the lock.
  ///
  /// - parameter graveyard: receives the removed listeners, to be released once the lock is released
  private func flushCancelledListenersLocked(_ graveyard: inout [Any]) {
    guard signalListeners.contains(where: { $0.observer == nil }) else {
      return
    }
    var remainingListeners: [SignalSubscription<T>] = []
    for signalListener in signalListeners {
      if signalListener.observer != nil {
        remainingListeners.append(signalListener)
      } else {
        graveyard.append(signalListener)
      }
    }
    signalListeners = remainingListeners
  }
}

public extension Signal where T == Void {
  func fire() {
    fire(())
  }
}

/// Runs `body` while holding the lock.
///
/// The objects which `body` appends to the provided graveyard are released only once the lock is released, so that
/// their deinitializers, which might re-enter the signal, cannot deadlock.
func synchronized<R>(_ lock: NSLock, _ body: (_ graveyard: inout [Any]) -> R) -> R {
  var graveyard: [Any] = []
  lock.lock()
  let result = body(&graveyard)
  lock.unlock()
  withExtendedLifetime(graveyard) {}
  return result
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

//
//  Observer.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// This is where you can change the implementation detail of the observer
/// If you want to change a new one, then you need just implement the Observable protocol
/// and then swap it here. Note that you will also have to implement a Subscription logic
/// that will conform to the Observation protocol (See Signals+Observable for more info)
public class Observer<P>: Observable {

  public typealias ParameterType = P
  public typealias Obs = Subscription<P>

  private let signal: Signal<P>

  public init(retainLastData: Bool = true) {
    self.signal = Signal<P>()
    self.retainLastData = retainLastData
  }

  /// Whether or not the `Signal` should retain a reference to the last data it was fired with. Defaults to false.
  public var retainLastData: Bool {
    get {
      return signal.retainLastData
    }
    set {
      signal.retainLastData = newValue
    }
  }

  /// The last data that the `Signal` was fired with. In order for the `Signal` to retain the last fired data, its
  /// `retainLastFired`-property needs to be set to true
  public var lastDataFired: ParameterType? {
    return signal.lastDataFired
  }

  /// Subscribes an observer to the `Signal`.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  /// - returns: A `SignalSubscription` that can be used to cancel or filter the subscription.
  @discardableResult public func subscribe<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Subscription<P> {
    return Subscription(signalSubscription: signal.subscribe(with: observer, callback: callback))
  }

  /// Subscribes an observer to the `Signal`. The subscription is automatically canceled after the `Signal` has
  /// fired once.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke when the signal fires for the first time.
  @discardableResult public func subscribeOnce<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Subscription<P> {
    return Subscription(signalSubscription: signal.subscribeOnce(with: observer, callback: callback))
  }

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  @discardableResult public func subscribePast<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Subscription<P> {
    return Subscription(signalSubscription: signal.subscribePast(with: observer, callback: callback))
  }

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true. If it has
  /// not been fired yet, it will continue listening until it fires for the first time.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the signal fires.
  @discardableResult public func subscribePastOnce<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Subscription<P> {
    return Subscription(signalSubscription: signal.subscribePastOnce(with: observer, callback: callback))
  }

  /// Cancels all subscriptions for an observer.
  ///
  /// - parameter observer: The observer whose subscriptions to cancel
  public func cancelSubscription(for observer: AnyObject) {
    signal.cancelSubscription(for: observer)
  }

  /// Cancels all subscriptions for the `Signal`.
  public func cancelAllSubscriptions() {
    signal.cancelAllSubscriptions()
  }

}

public extension Observer {

  func fire(_ data: P) {
    signal.fire(data)
  }

  func clearLastData() {
    signal.clearLastData()
  }

  var observers: [AnyObject] {
    return signal.observers
  }

}

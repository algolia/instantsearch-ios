//
//  Observable.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol Observable {

  associatedtype ParameterType
  associatedtype Obs: Observation

  typealias ObserverCallback<O: AnyObject> = (O, ParameterType) -> Void

  /// Whether or not the `Signal` should retain a reference to the last data it was fired with. Defaults to false.
  var retainLastData: Bool { get set }

  /// The last data that the `Signal` was fired with. In order for the `Signal` to retain the last fired data, its
  /// `retainLastFired`-property needs to be set to true
  var lastDataFired: ParameterType? { get }

  /// Subscribes an observer to the `Signal`.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  /// - returns: A `SignalSubscription` that can be used to cancel or filter the subscription.
  func subscribe<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Obs

  /// Subscribes an observer to the `Signal`. The subscription is automatically canceled after the `Signal` has
  /// fired once.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke when the signal fires for the first time.
  func subscribeOnce<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Obs

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  func subscribePast<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Obs

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true. If it has
  /// not been fired yet, it will continue listening until it fires for the first time.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the signal fires.
  func subscribePastOnce<O: AnyObject>(with observer: O, callback: @escaping ObserverCallback<O>) -> Obs

  /// Cancels all subscriptions for an observer.
  ///
  /// - parameter observer: The observer whose subscriptions to cancel
  func cancelSubscription(for observer: AnyObject)

  /// Cancels all subscriptions for the `Signal`.
  func cancelAllSubscriptions()

}

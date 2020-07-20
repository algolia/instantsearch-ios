//
//  Observation.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// A SignalLister represenents an instance and its association with a `Signal`.
public protocol Observation {

  associatedtype ParameterType

  typealias ObserverFilter = (ParameterType) -> Bool

  /// Whether the observer should be removed once it observes the `Signal` firing once. Defaults to false.
  var once: Bool { get set }

  /// Assigns a filter to the `SignalSubscription`. This lets you define conditions under which a observer should actually
  /// receive the firing of a `Singal`. The closure that is passed an argument can decide whether the firing of a
  /// `Signal` should actually be dispatched to its observer depending on the data fired.
  ///
  /// If the closeure returns true, the observer is informed of the fire. The default implementation always
  /// returns `true`.
  ///
  /// - parameter predicate: A closure that can decide whether the `Signal` fire should be dispatched to its observer.
  /// - returns: Returns self so you can chain calls.
  func filter(_ predicate: @escaping ObserverFilter) -> Self

  /// Tells the observer to sample received `Signal` data and only dispatch the latest data once the time interval
  /// has elapsed. This is useful if the subscriber wants to throttle the amount of data it receives from the
  /// `Signal`.
  ///
  /// - parameter sampleInterval: The number of seconds to delay dispatch.
  /// - returns: Returns self so you can chain calls.
  func sample(every sampleInterval: TimeInterval) -> Self

  /// Assigns a dispatch queue to the `SignalSubscription`. The queue is used for scheduling the observer calls. If not
  /// nil, the callback is fired asynchronously on the specified queue. Otherwise, the block is run synchronously
  /// on the posting thread, which is its default behaviour.
  ///
  /// - parameter queue: A queue for performing the observer's calls.
  /// - returns: Returns self so you can chain calls.
  func onQueue(_ queue: DispatchQueue) -> Self

  /// Cancels the observer. This will cancelSubscription the listening object from the `Signal`.
  func cancel()
}

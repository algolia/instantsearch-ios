//
//  NumberRangeInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum NumberRange {}

/// Numeric range filter business logic
public class NumberRangeInteractor<Number: Comparable & DoubleRepresentable>: ItemInteractor<ClosedRange<Number>?>, Boundable {

  /// Event triggered when range value has been changed by the business logic
  public let onNumberRangeComputed: Observer<ClosedRange<Number>?>

  /// Event triggered when bounds value has been changed by the business logic
  public let onBoundsComputed: Observer<ClosedRange<Number>?>

  /// Optional bounds limiting the max and the min value of the range
  public private(set) var bounds: ClosedRange<Number>?

  public convenience init() {
    self.init(item: nil)
    Telemetry.shared.trace(type: .numberRangeFilter)
  }

  /**
   - Parameters:
     - item: Initial range value
  */
  public override init(item: ClosedRange<Number>?) {
    self.onNumberRangeComputed = .init()
    self.onBoundsComputed = .init()
    super.init(item: item)
    Telemetry.shared.trace(type: .numberRangeFilter,
                           parameters: [
                            item == nil ? .none : .range
                           ])
  }

  /// Set the bounds value and clamps the current range value to it
  public func applyBounds(bounds: ClosedRange<Number>?) {
    let limitedRange = limitRange(item, limitedBy: bounds)
    self.bounds = bounds
    onBoundsComputed.fire(bounds)
    onNumberRangeComputed.fire(limitedRange)
  }

  public func computeNumberRange(numberRange: ClosedRange<Number>?) {
    let limitedRange = limitRange(numberRange, limitedBy: bounds)
    onNumberRangeComputed.fire(limitedRange)
  }

  private func limitRange(_ range: ClosedRange<Number>?, limitedBy bounds: ClosedRange<Number>?) -> ClosedRange<Number>? {
    guard let bounds = bounds else {
      return range
    }
    return range?.clamped(to: bounds)
  }

}

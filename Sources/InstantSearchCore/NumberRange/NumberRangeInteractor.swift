//
//  NumberRangeInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum NumberRange {}

public class NumberRangeInteractor<Number: Comparable & DoubleRepresentable>: ItemInteractor<ClosedRange<Number>?>, Boundable {

  public let onNumberRangeComputed: Observer<ClosedRange<Number>?>
  // TODO: Need to move that info at the view/controller level.
  public let onBoundsComputed: Observer<ClosedRange<Number>?>

  public private(set) var bounds: ClosedRange<Number>?

  public convenience init() {
    self.init(item: nil)
  }

  public override init(item: ClosedRange<Number>?) {
    self.onNumberRangeComputed = .init()
    self.onBoundsComputed = .init()
    super.init(item: item)
  }

  public func applyBounds(bounds: ClosedRange<Number>?) {
    let coerced: ClosedRange<Number>?
    if let bounds = bounds {
      coerced = item?.clamped(to: bounds)
    } else {
      coerced = item
    }

    self.bounds = bounds

    onBoundsComputed.fire(bounds)
    onNumberRangeComputed.fire(coerced)

  }

  public func computeNumberRange(numberRange: ClosedRange<Number>?) {
    let coerced: ClosedRange<Number>?
    if let bounds = bounds {
      coerced = numberRange?.clamped(to: bounds)
    } else {
      coerced = numberRange
    }

    onNumberRangeComputed.fire(coerced)
  }
}

//
//  NumberInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class NumberInteractor<Number: Comparable & DoubleRepresentable>: ItemInteractor<Number?>, Boundable {

  public let onNumberComputed: Observer<Number?>
  public let onBoundsComputed: Observer<ClosedRange<Number>?>

  public private(set) var bounds: ClosedRange<Number>?

  public convenience init() {
    self.init(item: nil)
    Telemetry.shared.trace(type: .numberFilter)
  }

  public override init(item: Number?) {
    self.onNumberComputed = .init()
    self.onBoundsComputed = .init()
    super.init(item: item)
    Telemetry.shared.trace(type: .numberFilter,
                           parameters: [
                            item == nil ? .none : .number
                           ])
  }

  public func applyBounds(bounds: ClosedRange<Number>?) {
    let coerced = item?.coerce(in: bounds)
    self.bounds = bounds

    onBoundsComputed.fire(bounds)
    onNumberComputed.fire(coerced)
  }

  public func computeNumber(number: Number?) {
    let coerced = number?.coerce(in: bounds)

    onNumberComputed.fire(coerced)
  }
}

extension Comparable {
  func coerce(in range: ClosedRange<Self>?) -> Self {
    guard let range = range else { return self }
    if self < range.lowerBound { return range.lowerBound }
    if self > range.upperBound { return range.upperBound }
    return self
  }
}

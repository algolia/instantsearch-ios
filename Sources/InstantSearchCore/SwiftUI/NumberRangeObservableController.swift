//
//  PriceController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class NumberRangeObservableController<Number: Comparable>: ObservableObject, NumberRangeController {

  @Published public var range: ClosedRange<Number> {
    didSet {
      if oldValue != range {
        onRangeChanged?(range)
      }
    }
  }

  @Published public var bounds: ClosedRange<Number>

  public var onRangeChanged: ((ClosedRange<Number>) -> Void)?

  public func setItem(_ item: ClosedRange<Number>) {
  }

  public func invalidate() {
  }

  private var isInitialBoundsSet: Bool = true

  public func setBounds(_ bounds: ClosedRange<Number>) {
    self.bounds = bounds
    if isInitialBoundsSet {
      isInitialBoundsSet = false
      self.range = bounds
    }
  }

  public init(range: ClosedRange<Number>,
              bounds: ClosedRange<Number>) {
    self.range = range
    self.bounds = bounds
  }

}

//
//  NumberRangeObservableController.swift
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// NumberRangeController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class NumberRangeObservableController<Number: Comparable & DoubleRepresentable>: ObservableObject, NumberRangeController {

  /// The numeric range value
  @Published public var range: ClosedRange<Number> = Number(0)...Number(1) {
    didSet {
      if oldValue != range {
        onRangeChanged?(range)
      }
    }
  }

  /// The bounds limiting the numeric range value
  @Published public var bounds: ClosedRange<Number> = Number(0)...Number(1)

  public var onRangeChanged: ((ClosedRange<Number>) -> Void)?

  private var isInitialBoundsSet: Bool = true

  public func setItem(_ range: ClosedRange<Number>) {
    self.range = range
  }

  public func setBounds(_ bounds: ClosedRange<Number>) {
    self.bounds = bounds
    if isInitialBoundsSet {
      isInitialBoundsSet = false
      self.range = bounds
    }
  }

  /**
   - parameters:
     - range: The numeric range value
     - bounds: The bounds limiting the numeric range value
   */
  public init(range: ClosedRange<Number> = Number(0)...Number(1),
              bounds: ClosedRange<Number> = Number(0)...Number(1)) {
    self.range = range.clamped(to: bounds)
    self.bounds = bounds
  }

}
#endif

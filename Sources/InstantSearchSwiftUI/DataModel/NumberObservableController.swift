//
//  NumberObservableController.swift
//  
//
//  Created by Vladislav Fitc on 04/07/2022.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// NumberController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class NumberObservableController<Number: Numeric & Comparable>: ObservableObject, NumberController {

  /// The numeric  value
  @Published public var value: Number {
    didSet {
      guard value != oldValue else { return }
      computation.just(value: value)
    }
  }

  /// The bounds limiting the numeric value
  @Published public var bounds: ClosedRange<Number>

  private var computation: Computation<Number>!

  public init(value: Number = 0,
              bounds: ClosedRange<Number> = 0...1000000) {
    self.value = value
    self.bounds = bounds
  }

  public func setItem(_ value: Number) {
    self.value = value
  }

  public func setBounds(bounds: ClosedRange<Number>?) {
    if let bounds = bounds {
      self.bounds = bounds
    }
  }

  public func setComputation(computation: Computation<Number>) {
    self.computation = computation
  }

}
#endif

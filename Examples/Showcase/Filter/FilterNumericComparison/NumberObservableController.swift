//
//  NumberObservableController.swift
//  Examples
//
//  Created by Vladislav Fitc on 27/04/2022.
//

import Foundation
import InstantSearchCore

public class NumberObservableController<Number: Numeric & Comparable>: ObservableObject, NumberController {
  
  @Published public var value: Number {
    didSet {
      guard value != oldValue else { return }
      computation.just(value: value)
    }
  }
  
  @Published public var bounds: ClosedRange<Number>
  
  private var computation: Computation<Number>!
  
  public init(value: Number = 0, bounds: ClosedRange<Number> = 0...1000000) {
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

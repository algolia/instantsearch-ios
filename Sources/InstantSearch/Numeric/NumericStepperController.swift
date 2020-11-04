//
//  FilterPriceView.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public class NumericStepperController: NumberController {

  public typealias Item = Double

  public func setItem(_ item: Double) {
    stepper.value = item
  }

  var computation: Computation<Double>?

  public func setComputation(computation: Computation<Double>) {
    self.computation = computation
    stepper.addTarget(self, action: #selector(stepperOnValueChanged), for: .valueChanged)
  }

  public func setBounds(bounds: ClosedRange<Double>?) {
    stepper.minimumValue = bounds?.lowerBound ?? 0
    stepper.maximumValue = bounds?.upperBound ?? .infinity
  }

  @objc func stepperOnValueChanged(sender: UIStepper) {
    computation?.just(value: sender.value)
  }

  public let stepper: UIStepper

  public init(stepper: UIStepper = .init()) {
    self.stepper = stepper
  }

  public func invalidate() {
    stepper.value = 0
  }

}
#endif

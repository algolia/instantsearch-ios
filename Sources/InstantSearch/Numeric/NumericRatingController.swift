//
//  NumericRatingController.swift
//  
//
//  Created by Vladislav Fitc on 04/11/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public class NumericRatingController {

  public let ratingControl: RatingControl

  var computation: Computation<Double>?

  public init(ratingControl: RatingControl = .init()) {
    self.ratingControl = ratingControl
  }

  @objc private func ratingValueChanged(_ ratingControl: RatingControl) {
    computation?.just(value: ratingControl.value)
  }

}

extension NumericRatingController: NumberController {

  public func setItem(_ item: Double) {
    ratingControl.value = item
  }

  public func setComputation(computation: Computation<Double>) {
    self.computation = computation
    ratingControl.addTarget(self, action: #selector(ratingValueChanged), for: .valueChanged)
  }

  public func setBounds(bounds: ClosedRange<Double>?) {
    if let upperBound = bounds?.upperBound {
      ratingControl.maximumValue = Int(upperBound)
    }
  }

  public func invalidate() {
    ratingControl.value = 0
  }

}

#endif

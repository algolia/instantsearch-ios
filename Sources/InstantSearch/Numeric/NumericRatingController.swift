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

  public init(ratingControl: RatingControl = .init()) {
    self.ratingControl = ratingControl
  }

}

extension NumericRatingController: NumberController {

  public func setItem(_ item: Double) {
    ratingControl.value = item
  }

  public func setComputation(computation: Computation<Double>) {

  }

  public func setBounds(bounds: ClosedRange<Double>?) {
    if let upperBound = bounds?.upperBound {
      ratingControl.maximumValue = Int(upperBound)
    }
  }

}

#endif

//
//  NumericRatingRangeController.swift
//
//
//  Created by Vladislav Fitc on 04/11/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public class NumericRatingRangeController {

  public let ratingControl: RatingControl

  public var onRangeChanged: ((ClosedRange<Double>) -> Void)?

  public init(ratingControl: RatingControl = .init()) {
    self.ratingControl = ratingControl
    ratingControl.addTarget(self, action: #selector(ratingValueChanged), for: .valueChanged)
  }

  @objc private func ratingValueChanged(_ ratingControl: RatingControl) {
    onRangeChanged?(ratingControl.value...Double(ratingControl.maximumValue))
  }

}

extension NumericRatingRangeController: NumberRangeController {

  public func setBounds(_ bounds: ClosedRange<Double>) {
    ratingControl.maximumValue = Int(bounds.upperBound)
  }

  public func setItem(_ item: ClosedRange<Double>) {
    ratingControl.value = item.lowerBound
  }

}

#endif

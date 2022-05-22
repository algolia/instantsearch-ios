//
//  NumericRangeController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

public class NumericRangeController: UIViewController, NumberRangeController {

  public typealias Number = Double

  public let lowerBoundLabel: UILabel
  public let upperBoundLabel: UILabel
  public let rangeSlider: RangeSlider

  public var onRangeChanged: ((ClosedRange<Double>) -> Void)?

  public func setItem(_ item: ClosedRange<Double>) {
    rangeSlider.lowerValue = item.lowerBound
    rangeSlider.upperValue = item.upperBound
  }

  @objc func onValueChanged(sender: RangeSlider) {
    onRangeChanged?(sender.lowerValue.rounded(toPlaces: 2)...sender.upperValue.rounded(toPlaces: 2))
  }

  public func setBounds(_ bounds: ClosedRange<Double>) {
    rangeSlider.minimumValue = bounds.lowerBound
    rangeSlider.maximumValue = bounds.upperBound
    setItem(bounds)
    lowerBoundLabel.text = "\(bounds.lowerBound.rounded(toPlaces: 2))"
    upperBoundLabel.text = "\(bounds.upperBound.rounded(toPlaces: 2))"
  }

  public init(rangeSlider: RangeSlider) {
    self.rangeSlider = rangeSlider
    self.lowerBoundLabel = .init()
    self.upperBoundLabel = .init()
    super.init(nibName: nil, bundle: nil)
    rangeSlider.addTarget(self, action: #selector(onValueChanged(sender:)), for: [.touchUpInside, .touchUpOutside])
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    lowerBoundLabel.translatesAutoresizingMaskIntoConstraints = false
    lowerBoundLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    lowerBoundLabel.textAlignment = .center

    upperBoundLabel.translatesAutoresizingMaskIntoConstraints = false
    upperBoundLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    upperBoundLabel.textAlignment = .center

    rangeSlider.translatesAutoresizingMaskIntoConstraints = false
    rangeSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true

    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 0
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.addArrangedSubview(lowerBoundLabel)
    stackView.addArrangedSubview(rangeSlider)
    stackView.addArrangedSubview(upperBoundLabel)
    view.addSubview(stackView)
    stackView.pin(to: view)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

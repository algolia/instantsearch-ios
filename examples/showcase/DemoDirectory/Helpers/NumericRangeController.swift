//
//  NumericRangeController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class NumericRangeController: UIViewController, NumberRangeController {
  public var onRangeChanged: ((ClosedRange<Double>) -> Void)?

  public typealias Number = Double

  public func setItem(_ item: ClosedRange<Double>) {
    rangerSlider.lowerValue = item.lowerBound
    rangerSlider.upperValue = item.upperBound
  }

  @objc func onValueChanged(sender: RangeSlider) {
    onRangeChanged?(sender.lowerValue.rounded(toPlaces: 2)...sender.upperValue.rounded(toPlaces: 2))
  }

  public func setBounds(_ bounds: ClosedRange<Double>) {
    rangerSlider.minimumValue = bounds.lowerBound
    rangerSlider.maximumValue = bounds.upperBound
    setItem(bounds)
    lowerBoundLabel.text = "\(bounds.lowerBound.rounded(toPlaces: 2))"
    upperBoundLabel.text = "\(bounds.upperBound.rounded(toPlaces: 2))"
  }

  
  public let lowerBoundLabel: UILabel
  public let upperBoundLabel: UILabel
  public let rangerSlider: RangeSlider

  public init(rangeSlider: RangeSlider) {
    self.rangerSlider = rangeSlider
    self.lowerBoundLabel = .init()
    self.upperBoundLabel = .init()
    super.init(nibName: nil, bundle: nil)
    rangeSlider.addTarget(self, action: #selector(onValueChanged(sender:)), for: [.touchUpInside, .touchUpOutside])
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    rangerSlider.translatesAutoresizingMaskIntoConstraints = false
    
    lowerBoundLabel.translatesAutoresizingMaskIntoConstraints = false
    lowerBoundLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    lowerBoundLabel.textAlignment = .center
    upperBoundLabel.translatesAutoresizingMaskIntoConstraints = false
    upperBoundLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    
    rangerSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    rangerSlider.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
    upperBoundLabel.textAlignment = .center
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = .px16
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.addArrangedSubview(lowerBoundLabel)
    stackView.addArrangedSubview(rangerSlider)
    stackView.addArrangedSubview(upperBoundLabel)
    view.addSubview(stackView)
    stackView.pin(to: view)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

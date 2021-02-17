//
//  DynamicSortToggleController.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
import UIKit

public class DynamicSortToggleView: UIView, DynamicSortToggleController {

  public let hintLabel: UILabel
  public let toggleButton: UIButton

  public var didToggle: (() -> Void)?

  override init(frame: CGRect) {
    hintLabel = .init()
    toggleButton = .init()
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func setItem(_ item: DynamicSortToggleInteractor.TextualRepresentation?) {
    isHidden = item == nil
    hintLabel.text = item?.hintText
    toggleButton.setTitle(item?.buttonTitle, for: .normal)
  }

  @objc func didTapToggleButton() {
    didToggle?()
  }

  func setupUI() {
    setupHintLabel()
    setupToggleButton()
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.addArrangedSubview(hintLabel)
    stackView.addArrangedSubview(toggleButton)
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func setupToggleButton() {
    toggleButton.translatesAutoresizingMaskIntoConstraints = false
    toggleButton.layer.borderWidth = 1
    toggleButton.layer.cornerRadius = 10
    toggleButton.layer.borderColor = tintColor.cgColor
    toggleButton.setTitleColor(self.tintColor, for: .normal)
    toggleButton.titleLabel?.font = .systemFont(ofSize: 10)
    toggleButton.addTarget(self, action: #selector(didTapToggleButton), for: .touchUpInside)
    toggleButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
    toggleButton.titleEdgeInsets = .init(top: 0, left: 3, bottom: 0, right: 3)
  }

  func setupHintLabel() {
    hintLabel.translatesAutoresizingMaskIntoConstraints = false
    hintLabel.font = .systemFont(ofSize: 14)
    hintLabel.numberOfLines = 0
  }

}

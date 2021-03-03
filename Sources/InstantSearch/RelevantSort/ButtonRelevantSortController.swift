//
//  ButtonRelevantSortController.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public class ButtonRelevantSortController: UIViewController, RelevantSortController {

  public let hintLabel: UILabel
  public let toggleButton: UIButton

  public var didToggle: (() -> Void)?

  public init() {
    hintLabel = .init()
    toggleButton = .init()
    super.init(nibName: nil, bundle: nil)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func setItem(_ item: RelevantSortTextualRepresentation?) {
    view.isHidden = item == nil
    hintLabel.text = item?.hintText
    toggleButton.setTitle(item?.toggleTitle, for: .normal)
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
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  func setupToggleButton() {
    toggleButton.translatesAutoresizingMaskIntoConstraints = false
    toggleButton.layer.borderWidth = 1
    toggleButton.layer.cornerRadius = 10
    toggleButton.layer.borderColor = view.tintColor.cgColor
    toggleButton.setTitleColor(view.tintColor, for: .normal)
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
#endif

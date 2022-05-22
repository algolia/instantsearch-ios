//
//  RelevantSortToggleController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25.03.2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class RelevantSortToggleController: UIViewController, RelevantSortController {

  var didToggle: (() -> Void)?

  let label: UILabel
  let button: UIButton

  init() {
    self.label = .init()
    self.button = .init()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }

  func layout() {
    label.numberOfLines = 2
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 12)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = .systemFont(ofSize: 12)
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(.blue, for: .normal)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(button)
    view.addSubview(stackView)
    stackView.pin(to: view, insets: .init(top: 0, left: 0, bottom: 0, right: 0))
  }

  func setItem(_ item: RelevantSortTextualRepresentation?) {
    guard let item = item else {
      label.text = nil
      button.setTitle(nil, for: .normal)
      view.isHidden = true
      return
    }
    view.isHidden = false
    label.text = item.hintText
    button.setTitle(item.toggleTitle, for: .normal)
  }

  @objc func didTapButton() {
    didToggle?()
  }

}

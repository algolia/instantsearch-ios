//
//  ViewController.swift
//  FilterList
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import UIKit

class MainViewController: UIViewController {

  let segmentedControl: UISegmentedControl
  let viewStack: UIStackView

  init() {
    segmentedControl = .init()
    viewStack = .init()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    configureSegmentedControl()
  }

  private func configureSegmentedControl() {
    [
      "Facet",
      "Numeric",
      "Tag"
    ]
      .enumerated()
      .forEach { index, title in
        segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
      }
    segmentedControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.sendActions(for: .valueChanged)
  }

  @objc private func didSelectSegment() {
    for (index, view) in viewStack.arrangedSubviews.enumerated() {
      view.isHidden = segmentedControl.selectedSegmentIndex != index
    }
  }

  private func layout() {
    title = "Filter List"
    view.backgroundColor = .systemBackground

    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    let segmentedControlContainer = UIView()
    segmentedControlContainer.translatesAutoresizingMaskIntoConstraints = false
    segmentedControlContainer.addSubview(segmentedControl)
    segmentedControl.pin(to: segmentedControlContainer, insets: .init(top: 0, left: 10, bottom: 0, right: -10))

    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.translatesAutoresizingMaskIntoConstraints = false

    viewStack.axis = .horizontal
    viewStack.translatesAutoresizingMaskIntoConstraints = false
    let viewControllers = [
      FilterListDemo.facet(),
      FilterListDemo.numeric(),
      FilterListDemo.tag()
    ]

    for viewController in viewControllers {
      addChild(viewController)
      viewController.didMove(toParent: self)
      viewController.view.translatesAutoresizingMaskIntoConstraints = false
      viewStack.addArrangedSubview(viewController.view)
    }

    mainStackView.addArrangedSubview(segmentedControlContainer)
    mainStackView.addArrangedSubview(viewStack)
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }

}

//
//  SearchDebugViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchCore

class SearchDebugViewController: UIViewController {
  
  let statsInteractor: StatsInteractor
  let loadingInteractor: LoadingInteractor
  let filterClearInteractor: FilterClearInteractor
  
  let mainStackView: UIStackView
  let titleLabel: UILabel
  let hitsCountLabel: UILabel
  let activityIndicator: UIActivityIndicatorView
  let filterStateViewController: FiltersDebugViewController
  let clearRefinementsButton: UIButton
  let activityIndicatorController: ActivityIndicatorController
  let clearRefinementsController: FilterClearButtonController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.mainStackView = UIStackView(frame: .zero)
    self.titleLabel = UILabel(frame: .zero)
    self.hitsCountLabel = UILabel(frame: .zero)
    self.activityIndicator = UIActivityIndicatorView(frame: .zero)
    self.filterStateViewController = FiltersDebugViewController()
    self.clearRefinementsButton = UIButton(frame: .zero)
    self.activityIndicatorController = ActivityIndicatorController(activityIndicator: activityIndicator)
    self.clearRefinementsController = FilterClearButtonController(button: clearRefinementsButton)
    self.statsInteractor = .init()
    self.loadingInteractor = .init()
    self.filterClearInteractor = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    loadingInteractor.connectController(activityIndicatorController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    configureMainStackView()
    configureTitleLabel()
    configureClearRefinementsButton()
    configureFilterStateViewController()
    configureHitsCountLabel()
    configureActivityIndicator()
    configureLayout()
  }
  
  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = 4
    mainStackView.layoutMargins = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.addBackground(color: .white)
    mainStackView.alignment = .leading
    mainStackView.subviews.first.flatMap {
      $0.layer.borderWidth = 0.5
      $0.layer.borderColor = UIColor.black.cgColor
      $0.layer.masksToBounds = true
      $0.layer.cornerRadius = 10
    }
  }
  
  func configureTitleLabel() {
    titleLabel.font = .boldSystemFont(ofSize: 25)
    titleLabel.text = "Filters"
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureHitsCountLabel() {
    hitsCountLabel.textColor = .black
    hitsCountLabel.font = .systemFont(ofSize: 12)
    hitsCountLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureActivityIndicator() {
    activityIndicator.style = .medium
    activityIndicator.hidesWhenStopped = true
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureClearRefinementsButton() {
    clearRefinementsButton.setImage(UIImage(named: "trash"), for: .normal)
    clearRefinementsButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureFilterStateViewController() {
    filterStateViewController.colorMap = [
      "_tags": UIColor(hexString: "#9673b4"),
      "size": UIColor(hexString: "#698c28"),
      "color": .red,
      "promotions": .blue,
      "category": .green
    ]
  }
  
  func configureLayout() {
    
    view.addSubview(mainStackView)

    mainStackView.pin(to: view.safeAreaLayoutGuide, insets: .init(top: 0, left: 4, bottom: 0, right: -4))
    
    let topStackView = UIStackView(frame: .zero)
    topStackView.translatesAutoresizingMaskIntoConstraints = false
    topStackView.axis = .horizontal
    topStackView.distribution = .fill
    
    topStackView.addArrangedSubview(titleLabel)
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    topStackView.addArrangedSubview(view)
    topStackView.addArrangedSubview(clearRefinementsButton)
    
    mainStackView.addArrangedSubview(topStackView)
    topStackView.leadingAnchor.constraint(equalTo: mainStackView.layoutMarginsGuide.leadingAnchor).isActive = true
    topStackView.trailingAnchor.constraint(equalTo: mainStackView.layoutMarginsGuide.trailingAnchor).isActive = true

    addChild(filterStateViewController)
    filterStateViewController.didMove(toParent: self)
    
    mainStackView.addArrangedSubview(filterStateViewController.stateLabel)
    
    let bottomStackView = UIStackView(frame: .zero)
    bottomStackView.translatesAutoresizingMaskIntoConstraints = false
    bottomStackView.axis = .horizontal
    bottomStackView.distribution = .fill
    
    bottomStackView.addArrangedSubview(hitsCountLabel)
    let view2 = UIView()
    view2.setContentHuggingPriority(.defaultLow, for: .horizontal)
    bottomStackView.addArrangedSubview(view2)
    bottomStackView.addArrangedSubview(activityIndicator)
    
    mainStackView.addArrangedSubview(bottomStackView)
    bottomStackView.leadingAnchor.constraint(equalTo: mainStackView.layoutMarginsGuide.leadingAnchor).isActive = true
    bottomStackView.trailingAnchor.constraint(equalTo: mainStackView.layoutMarginsGuide.trailingAnchor).isActive = true
  }
  
}

extension SearchDebugViewController {
  
  func connectFilterState(_ filterState: FilterState) {
    filterStateViewController.connectTo(filterState)
    filterClearInteractor.connectFilterState(filterState)
    filterClearInteractor.connectController(clearRefinementsController)
  }
  
  func connectSearcher(_ searcher: HitsSearcher) {
    loadingInteractor.connectSearcher(searcher)
    statsInteractor.connectSearcher(searcher)
  }
  
  func connectFacetSearcher(_ facetSearcher: FacetSearcher) {
    loadingInteractor.connectSearcher(facetSearcher)
  }
  
}

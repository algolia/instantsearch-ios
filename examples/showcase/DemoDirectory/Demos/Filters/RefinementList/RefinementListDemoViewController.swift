//
//  RefinementListDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

extension UIColor {
  static let swBackground = UIColor(hexString: "#f7f8fa")
}

extension CGFloat {
  static let px16: CGFloat = 16
}

class RefinementListDemoViewController: UIViewController {
  
  let controller: RefinementListDemoController

  let searchStateViewController: SearchStateViewController
  let colorController: FacetListTableController
  let categoryController: FacetListTableController
  let promotionController: FacetListTableController
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchStateViewController = .init()
    
    // Color
    let colorTitleDescriptor = TitleDescriptor(text: "And, IsRefined-AlphaAsc, I=3", color: .init(hexString: "#ffcc0000"))
    colorController = FacetListTableController(tableView: .init(), titleDescriptor: colorTitleDescriptor)
    
    // Promotion
    let promotionTitleDescriptor = TitleDescriptor(text: "And, CountDesc, I=5", color: .init(hexString: "#ff669900"))
    promotionController = FacetListTableController(tableView: .init(), titleDescriptor: promotionTitleDescriptor)
        
    // Category
    let categoryTitleDescriptor = TitleDescriptor(text: "Or, CountDesc-AlphaAsc, I=5", color: .init(hexString: "#ff0099cc"))
    categoryController = .init(tableView: .init(), titleDescriptor: categoryTitleDescriptor)
    
    controller = .init(colorController: colorController,
                       promotionController: promotionController,
                       categoryController: categoryController)
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension RefinementListDemoViewController {
  
  func setup() {
    searchStateViewController.connectSearcher(controller.searcher)
    searchStateViewController.connectFilterState(controller.filterState)
  }
  
}

extension RefinementListDemoViewController {
  
  func setupUI() {
    
    view.backgroundColor = .swBackground
    
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = .px16
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchStateViewController.view)
    
    let gridStackView = UIStackView()
    gridStackView.axis = .horizontal
    gridStackView.spacing = .px16
    gridStackView.distribution = .fillEqually
    
    gridStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let firstColumn = UIStackView()
    firstColumn.axis = .vertical
    firstColumn.spacing = .px16
    firstColumn.distribution = .fillEqually
    
    firstColumn.addArrangedSubview(colorController.tableView)
    firstColumn.addArrangedSubview(promotionController.tableView)
    
    gridStackView.addArrangedSubview(firstColumn)
    gridStackView.addArrangedSubview(categoryController.tableView)
    
    mainStackView.addArrangedSubview(gridStackView)
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
    [
      colorController,
      promotionController,
      categoryController
    ]
      .map { $0.tableView }
      .forEach {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        $0.alwaysBounceVertical = false
        $0.tableFooterView = UIView(frame: .zero)
        $0.backgroundColor = .swBackground
    }
    
  }
  
}

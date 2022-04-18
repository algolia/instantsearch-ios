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

class FacetListDemoViewController: UIViewController {
  
  let controller: FacetListDemoController

  let colorController: FacetListTableController
  let categoryController: FacetListTableController
  let promotionController: FacetListTableController
  let searchDebugViewController: SearchDebugViewController
    
  init() {
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
    searchDebugViewController = .init(filterState: controller.filterState)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

extension FacetListDemoViewController {
  
  func setupUI() {
    
    title = "Facet List"
    view.backgroundColor = .swBackground
    
    let mainStackView = UIStackView()
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.axis = .vertical
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    addChild(searchDebugViewController)
    searchDebugViewController.didMove(toParent: self)
    searchDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchDebugViewController.view)
    
    let gridStackView = UIStackView()
    gridStackView.axis = .horizontal
    gridStackView.spacing = 10
    gridStackView.distribution = .fillEqually
    
    gridStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let firstColumn = UIStackView()
    firstColumn.axis = .vertical
    firstColumn.spacing = 10
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

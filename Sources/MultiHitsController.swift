//
//  MultiHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 22/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public protocol MultiHitsDataSource: class {
  
  func numberOfSections() -> Int
  func numberOfRows(inSection: Int) -> Int
  func hitsViewModel<R>(atIndex index: Int) throws -> HitsViewModel<R>
  
}

extension MultiHitsViewModel: MultiHitsDataSource {}

public protocol MultiHitsWidget: class {
  
  associatedtype SingleHitView
  
  var viewModel: MultiHitsViewModel? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

public class MultiHitsController<HitsWidget: MultiHitsWidget>: NSObject {
  
  public let viewModel: MultiHitsViewModel
  public weak var widget: HitsWidget?
  
  public init(widget: HitsWidget, viewModel: MultiHitsViewModel) {
    self.viewModel = viewModel
    self.widget = widget
  }
  
  public convenience init(widget: HitsWidget) {
    let viewModel = MultiHitsViewModel()
    self.init(widget: widget, viewModel: viewModel)
    widget.viewModel = viewModel
  }
  
}

extension Playground {
  
  func multihitsPlay() {
    
    let tableView = UITableView()
    let widget = TableViewMultiHitsWidget(tableView: tableView)
    
    let dataSource = TableViewMultiHitsDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (_: JSON) in return UITableViewCell() }
    dataSource.setCellConfigurator(forSection: 1) { (_: [String: Int]) in return UITableViewCell() }

    let delegate = TableViewMultiHitsDelegate()
    
    delegate.setClickHandler(forSection: 0) { (_: JSON) in print("click") }
    delegate.setClickHandler(forSection: 1) { (_: [String: Int]) in print("click") }
    
    let controller = MultiHitsController(widget: widget)
    
    controller.viewModel.insert(hitsViewModel: HitsViewModel<[String: Int]>(), atIndex: 0)
    controller.viewModel.insert(hitsViewModel: HitsViewModel<JSON>(), atIndex: 1)

  }
  
}

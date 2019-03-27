//
//  TableViewHitsWidget.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

open class TableViewHitsDataSource<DataSource: HitsDataSource>: NSObject, UITableViewDataSource {
  
  public var cellConfigurator: HitViewConfigurator<DataSource.Hit, UITableViewCell>
  public weak var hitsDataSource: DataSource?
  
  public init(cellConfigurator: @escaping HitViewConfigurator<DataSource.Hit, UITableViewCell>) {
    self.cellConfigurator = cellConfigurator
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsDataSource?.numberOfRows() ?? 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let hit = hitsDataSource?.hitForRow(atIndex: indexPath.row) else {
      return UITableViewCell()
    }
    return cellConfigurator(hit)
  }
  
}

open class TableViewHitsDelegate<DataSource: HitsDataSource>: NSObject, UITableViewDelegate {
  
  public var clickHandler: HitClickHandler<DataSource.Hit>
  public weak var hitsDataSource: DataSource?
  
  public init(clickHandler: @escaping HitClickHandler<DataSource.Hit>) {
    self.clickHandler = clickHandler
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let hit = hitsDataSource?.hitForRow(atIndex: indexPath.row) else {
      return
    }
    clickHandler(hit)
  }
  
}

public class TableViewHitsWidget<Hit: Codable>: NSObject, HitsWidget {
  
  public typealias ViewModel = HitsViewModel<Hit>
  
  public typealias SingleHitView = UITableViewCell
  
  public let tableView: UITableView
  
  public weak var viewModel: ViewModel? {
    didSet {
      dataSource?.hitsDataSource = viewModel
      delegate?.hitsDataSource = viewModel
    }
  }
  
  public var dataSource: TableViewHitsDataSource<ViewModel>? {
    didSet {
      dataSource?.hitsDataSource = viewModel
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: TableViewHitsDelegate<ViewModel>? {
    didSet {
      delegate?.hitsDataSource = viewModel
      tableView.delegate = delegate
    }
  }
  
  public init(tableView: UITableView) {
    self.tableView = tableView
  }
  
  public func reload() {
    tableView.reloadData()
  }
  
  public func scrollToTop() {
    tableView.scrollToRow(at: IndexPath(), at: .top, animated: false)
  }

}

public typealias TableViewHitsController<Hit: Codable> = HitsController<TableViewHitsWidget<Hit>>

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

public typealias TableViewCellConfigurator<Hit> = HitViewConfigurator<UITableView, UITableViewCell, Hit>
public typealias TableViewClickHandler<Hit> = HitClickHandler<UITableView, Hit>

open class TableViewHitsDataSource<DataSource: HitsSource>: NSObject, UITableViewDataSource {
  
  public var cellConfigurator: TableViewCellConfigurator<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(cellConfigurator: @escaping TableViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
  }
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return UITableViewCell()
    }
    return cellConfigurator(tableView, hit, indexPath)
  }
  
}

open class TableViewHitsDelegate<DataSource: HitsSource>: NSObject, UITableViewDelegate {
  
  public var clickHandler: TableViewClickHandler<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(clickHandler: @escaping TableViewClickHandler<DataSource.Record>) {
    self.clickHandler = clickHandler
  }
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return
    }
    clickHandler(tableView, hit, indexPath)
  }
  
}

public class TableViewHitsWidget<Source: HitsSource>: NSObject, InstantSearchCore.HitsController {
  
  public let tableView: UITableView
  
  public weak var hitsSource: Source? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }
  
  public var dataSource: TableViewHitsDataSource<Source>? {
    didSet {
      dataSource?.hitsSource = hitsSource
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: TableViewHitsDelegate<Source>? {
    didSet {
      delegate?.hitsSource = hitsSource
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

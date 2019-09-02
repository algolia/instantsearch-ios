//
//  HitsTableController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public typealias TableViewCellConfigurator<Item> = HitViewConfigurator<UITableView, UITableViewCell, Item>
public typealias TableViewClickHandler<Item> = HitClickHandler<UITableView, Item>

public class HitsTableController<Source: HitsSource>: NSObject, HitsController, HitsTableViewContainer {
  
  public var hitsTableView: UITableView {
    return tableView
  }
  
  public let tableView: UITableView
  
  public weak var hitsSource: Source? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }
  
  @available(*, deprecated, message: "Use your own UITableViewController conforming to HitsController protocol")
  public var dataSource: HitsTableViewDataSource<Source>? {
    didSet {
      dataSource?.hitsSource = hitsSource
      tableView.dataSource = dataSource
    }
  }
  
  @available(*, deprecated, message: "Use your own UITableViewController conforming to HitsController protocol")
  public var delegate: HitsTableViewDelegate<Source>? {
    didSet {
      delegate?.hitsSource = hitsSource
      tableView.delegate = delegate
    }
  }
  
  public init(tableView: UITableView) {
    self.tableView = tableView
  }
  
  // These functions are implemented in the protocol extension, but should be there till
  // compiler bug is fixed

  public func reload() {
    hitsTableView.reloadData()
  }
  
  public func scrollToTop() {
    guard hitsTableView.numberOfRows(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(row: 0, section: 0)
    self.hitsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
  }
  
}

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

public class HitsTableController<Source: HitsSource>: NSObject, HitsController {
  
  public let tableView: UITableView
  
  public weak var hitsSource: Source? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }
  
  public var dataSource: HitsTableViewDataSource<Source>? {
    didSet {
      dataSource?.hitsSource = hitsSource
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: HitsTableViewDelegate<Source>? {
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
    guard tableView.numberOfRows(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(row: 0, section: 0)
    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
  }

}

//
//  MultiIndexHitsTableViewController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class MultiIndexHitsTableController: NSObject, MultiIndexHitsController {
    
  public let tableView: UITableView
  
  public weak var hitsSource: MultiIndexHitsSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }
  
  public var dataSource: MultiIndexHitsTableViewDataSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: MultiIndexHitsTableViewDelegate? {
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

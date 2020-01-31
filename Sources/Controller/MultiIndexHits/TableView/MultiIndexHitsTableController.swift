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

public class MultiIndexHitsTableController: NSObject, HitsTableViewContainer, MultiIndexHitsController {
  
  public var hitsTableView: UITableView {
    return tableView
  }
    
  public let tableView: UITableView
  
  public weak var hitsSource: MultiIndexHitsSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }
  
  @available(*, deprecated, message: "Use your own UITableViewController conforming to HitsController protocol")
  public var dataSource: MultiIndexHitsTableViewDataSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      tableView.dataSource = dataSource
    }
  }
  
  @available(*, deprecated, message: "Use your own UITableViewController conforming to HitsController protocol")
  public var delegate: MultiIndexHitsTableViewDelegate? {
    didSet {
      delegate?.hitsSource = hitsSource
      tableView.delegate = delegate
    }
  }
  
  public init(tableView: UITableView) {
    self.tableView = tableView
  }
  
}

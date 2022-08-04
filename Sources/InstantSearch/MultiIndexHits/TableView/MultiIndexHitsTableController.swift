//
//  MultiIndexHitsTableViewController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

@available(*, unavailable, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
@available(*, deprecated, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
public class MultiIndexHitsTableController: NSObject, HitsTableViewContainer, MultiIndexHitsController {

  public var hitsTableView: UITableView {
    return tableView
  }

  public let tableView: UITableView

  @available(*, deprecated, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
  public weak var hitsSource: MultiIndexHitsSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }

  @available(*, deprecated, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
  public var dataSource: MultiIndexHitsTableViewDataSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      tableView.dataSource = dataSource
    }
  }

  @available(*, deprecated, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
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
#endif

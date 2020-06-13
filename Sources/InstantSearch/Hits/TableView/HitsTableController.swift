//
//  HitsTableController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public typealias TableViewCellConfigurator<Item> = HitViewConfigurator<UITableView, UITableViewCell, Item>
public typealias TableViewClickHandler<Item> = HitClickHandler<UITableView, Item>

@available(*, unavailable, message: "Use your own UITableViewController conforming to HitsController protocol")
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
#endif

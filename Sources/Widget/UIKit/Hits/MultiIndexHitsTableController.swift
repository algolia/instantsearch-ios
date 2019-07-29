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

open class MultiIndexHitsTableViewDataSource: NSObject {
  
  private typealias CellConfigurator = (UITableView, Int) throws -> UITableViewCell
  
  public weak var hitsSource: MultiIndexHitsSource?
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  public override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  public func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping TableViewCellConfigurator<Hit>) {
    cellConfigurators[section] = { [weak self] (tableView, row) in
      guard let hit: Hit = try self?.hitsSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to deqeue a cell for a missing hit in a hits Interactor")
        return UITableViewCell()
      }
      return cellConfigurator(tableView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension MultiIndexHitsTableViewDataSource: UITableViewDataSource {
  
  open func numberOfSections(in tableView: UITableView) -> Int {
    guard let numberOfSections = hitsSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let numberOfRows = hitsSource?.numberOfHits(inSection: section) else {
      return 0
    }
    return numberOfRows
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    do {
      return try cellConfigurators[indexPath.section]?(tableView, indexPath.row) ?? UITableViewCell()
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

open class MultiIndexHitsTableViewDelegate: NSObject {
  
  typealias ClickHandler = (UITableView, Int) throws -> Void
  
  public weak var hitsSource: MultiIndexHitsSource?
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping TableViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (tableView, row) in
      guard let hit: Hit = try self?.hitsSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits Interactor")
        return
      }
      clickHandler(tableView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension MultiIndexHitsTableViewDelegate: UITableViewDelegate {
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(tableView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

public class MultiIndexHitsTableController: NSObject, InstantSearchCore.MultiIndexHitsController {
  
  public typealias SingleHitView = UITableViewCell
  
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

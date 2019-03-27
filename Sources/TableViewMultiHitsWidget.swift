//
//  TableViewMultiHitsWidget.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

open class TableViewMultiHitsDataSource: NSObject {
  
  private typealias CellConfigurator = (Int) throws -> UITableViewCell
  
  public weak var dataSource: MultiHitsDataSource? {
    didSet {
      cellConfigurators.removeAll()
    }
  }
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping HitViewConfigurator<Hit, UITableViewCell>) {
    cellConfigurators[section] = { [weak self] row in
      guard let dataSource = self?.dataSource else { return UITableViewCell() }
      let sectionViewModel = try dataSource.hitsViewModel(atIndex: section) as HitsViewModel<Hit>
      guard let hit = sectionViewModel.hitForRow(atIndex: row) else {
        assertionFailure("Invalid state: Attempt to deqeue a cell for a missing hit in a hits ViewModel")
        return UITableViewCell()
      }
      return cellConfigurator(hit)
    }
  }
  
}

extension TableViewMultiHitsDataSource: UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    guard let numberOfSections = dataSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let numberOfRows = dataSource?.numberOfRows(inSection: section) else {
      return 0
    }
    return numberOfRows
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    do {
      return try cellConfigurators[indexPath.section]?(indexPath.row) ?? UITableViewCell()
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

open class TableViewMultiHitsDelegate: NSObject {
  
  typealias ClickHandler = (Int) throws -> Void
  
  public weak var dataSource: MultiHitsDataSource? {
    didSet {
      clickHandlers.removeAll()
    }
  }
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping HitClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] row in
      guard let dataSource = self?.dataSource else { return }
      let sectionViewModel = try dataSource.hitsViewModel(atIndex: section) as HitsViewModel<Hit>
      guard let hit = sectionViewModel.hitForRow(atIndex: row) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits ViewModel")
        return
      }
      clickHandler(hit)
    }
  }
  
}

extension TableViewMultiHitsDelegate: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

class TableViewMultiHitsWidget: NSObject, MultiHitsWidget {
  
  typealias SingleHitView = UITableViewCell
  
  let tableView: UITableView
  
  public weak var viewModel: MultiHitsViewModel? {
    didSet {
      dataSource?.dataSource = viewModel
      delegate?.dataSource = viewModel
    }
  }
  
  public var dataSource: TableViewMultiHitsDataSource? {
    didSet {
      dataSource?.dataSource = viewModel
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: TableViewMultiHitsDelegate? {
    didSet {
      delegate?.dataSource = viewModel
      tableView.delegate = delegate
    }
  }
  
  init(tableView: UITableView) {
    self.tableView = tableView
  }
  
  func reload() {
    tableView.reloadData()
  }
  
  func scrollToTop() {
    tableView.scrollToRow(at: IndexPath(), at: .top, animated: false)
  }

}

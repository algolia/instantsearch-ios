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
  
  public weak var hitsDataSource: MultiHitsDataSource? {
    didSet {
      cellConfigurators.removeAll()
    }
  }
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  public func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping HitViewConfigurator<Hit, UITableViewCell>) {
    cellConfigurators[section] = { [weak self] row in
      guard let dataSource = self?.hitsDataSource else { return UITableViewCell() }
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
    guard let numberOfSections = hitsDataSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let numberOfRows = hitsDataSource?.numberOfRows(inSection: section) else {
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
  
  public weak var hitsDataSource: MultiHitsDataSource? {
    didSet {
      clickHandlers.removeAll()
    }
  }
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping HitClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] row in
      guard let dataSource = self?.hitsDataSource else { return }
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
  
  public let tableView: UITableView
  
  public weak var viewModel: MultiHitsViewModel? {
    didSet {
      dataSource?.hitsDataSource = viewModel
      delegate?.hitsDataSource = viewModel
    }
  }
  
  public var dataSource: TableViewMultiHitsDataSource? {
    didSet {
      dataSource?.hitsDataSource = viewModel
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: TableViewMultiHitsDelegate? {
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

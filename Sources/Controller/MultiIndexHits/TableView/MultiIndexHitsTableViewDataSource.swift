//
//  MultiIndexHitsTableViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
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

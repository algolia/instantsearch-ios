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
  
  public func setCellConfigurator<Hit: Codable>(forSection section: Int,
                                                templateCellProvider: @escaping () -> UITableViewCell = { return .init() },
                                                _ cellConfigurator: @escaping TableViewCellConfigurator<Hit>) {
    cellConfigurators[section] = { [weak self] (tableView, row) in
      guard let dataSource = self else {
        return .init()
      }
      
      guard let hitsSource = dataSource.hitsSource else {
        fatalError("Missing hits source")
      }
      
      guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
        return templateCellProvider()
      }
      
      return cellConfigurator(tableView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension MultiIndexHitsTableViewDataSource: UITableViewDataSource {
  
  open func numberOfSections(in tableView: UITableView) -> Int {
    guard let hitsSource = hitsSource else {
      fatalError("Missing hits source")
    }
    return hitsSource.numberOfSections()
  }
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let hitsSource = hitsSource else {
      fatalError("Missing hits source")
    }
    return hitsSource.numberOfHits(inSection: section)
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellConfigurator = cellConfigurators[indexPath.section] else {
      fatalError("No cell configurator found for section \(indexPath.section)")
    }
    do {
      return try cellConfigurator(tableView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

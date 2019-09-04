//
//  HitsTableViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class HitsTableViewDataSource<DataSource: HitsSource>: NSObject, UITableViewDataSource {
  
  public var cellConfigurator: TableViewCellConfigurator<DataSource.Record>
  public var templateCellProvider: () -> UITableViewCell
  public weak var hitsSource: DataSource?
  
  public init(cellConfigurator: @escaping TableViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
    self.templateCellProvider = { return .init() }
  }
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let hitsSource = hitsSource else {
      fatalError("Missing hits source")
    }
    
    return hitsSource.numberOfHits()
    
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let hitsSource = hitsSource else {
      fatalError("Missing hits source")
    }
    
    guard let hit = hitsSource.hit(atIndex: indexPath.row) else {
      return templateCellProvider()
    }
    
    return cellConfigurator(tableView, hit, indexPath)
    
  }
  
}

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
  public weak var hitsSource: DataSource?
  
  public init(cellConfigurator: @escaping TableViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
  }
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return UITableViewCell()
    }
    return cellConfigurator(tableView, hit, indexPath)
  }
  
}

//
//  HitsTableViewDelegate.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class HitsTableViewDelegate<DataSource: HitsSource>: NSObject, UITableViewDelegate {
  
  public var clickHandler: TableViewClickHandler<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(clickHandler: @escaping TableViewClickHandler<DataSource.Record>) {
    self.clickHandler = clickHandler
  }
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return
    }
    clickHandler(tableView, hit, indexPath)
  }
  
}

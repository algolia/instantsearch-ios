//
//  UITableViewController+HitsTableViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

import Foundation

#if canImport(UIKit)
import UIKit

extension UITableViewController: HitsTableViewContainer {
  
  public var hitsTableView: UITableView {
    return tableView
  }
  
}
#endif

//
//  UITableViewController+HitsTableViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

import Foundation

#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

extension UITableViewController: HitsTableViewContainer {

  public var hitsTableView: UITableView {
    return tableView
  }

}
#endif

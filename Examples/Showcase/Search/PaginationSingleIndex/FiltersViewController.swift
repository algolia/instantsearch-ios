//
//  FiltersViewController.swift
//  PaginationSingleIndex
//
//  Created by Vladislav Fitc on 03.10.2023.
//

import Foundation
import UIKit
import InstantSearch

final class FiltersViewController: UITableViewController {
  
  private(set) var tableController: FacetListTableController!
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.tableController = .init(tableView: tableView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

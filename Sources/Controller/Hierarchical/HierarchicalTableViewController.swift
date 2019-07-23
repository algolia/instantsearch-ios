//
//  HierarchicalTableViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 08/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

open class HierarchicalTableViewController: NSObject, HierarchicalController {

  public var onClick: ((String) -> Void)?
  var items: [HierarchicalFacet]
  var tableView: UITableView
  let cellID: String

  public init(tableView: UITableView, cellID: String = "HierarchicalFacet") {
    self.tableView = tableView
    self.items = []
    self.cellID = cellID

    super.init()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    tableView.dataSource = self
    tableView.delegate = self
  }

  public func setItem(_ item: [HierarchicalFacet]) {

    self.items = item

    tableView.reloadData()
  }

}

extension HierarchicalTableViewController: UITableViewDataSource {

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

    let maxSelectedLevel = Set(items.filter { $0.isSelected }.map { $0.level }).max() ?? 0
    let item = items[indexPath.row]
    cell.textLabel?.text = "\(item.facet.description)"
    cell.indentationLevel = item.level
    cell.accessoryType = item.level == maxSelectedLevel && item.isSelected ? .checkmark : .none
    return cell

  }
}

extension HierarchicalTableViewController: UITableViewDelegate {
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    onClick?(item.facet.value)
  }
}

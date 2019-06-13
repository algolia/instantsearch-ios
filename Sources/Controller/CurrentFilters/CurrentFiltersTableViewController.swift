//
//  CurrentFiltersTableViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

open class CurrentFilterListTableController: NSObject, ItemListController, UITableViewDataSource, UITableViewDelegate {

  public typealias Item = FilterAndID

  open var onRemoveItem: ((FilterAndID) -> Void)?

  public let tableView: UITableView

  public var items: [FilterAndID] = []
  public var filterFormatter: FilterPresenter?

  private let cellIdentifier = "CurrentFilterListTableControllerCellID"

  public init(tableView: UITableView) {
    self.tableView = tableView
    super.init()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }

  open func setItems(_ item: Set<FilterAndID>) {
    items = Array(item)
  }

  open func reload() {
    tableView.reloadData()
  }

  // MARK: - UITableViewDataSource

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let filterAndID = items[indexPath.row]
    let filterPresenter = self.filterFormatter ?? DefaultFilterPresenter.present
    cell.textLabel?.text = filterPresenter(filterAndID.filter)

    return cell
  }

  // MARK: - UITableViewDelegate

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onRemoveItem?(items[indexPath.row])
  }

}

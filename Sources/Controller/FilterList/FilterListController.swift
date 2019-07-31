//
//  FilterListController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

open class FilterListTableViewController<F: FilterType>: NSObject, SelectableListController, UITableViewDataSource, UITableViewDelegate {
  
  public typealias Item = F
  
  open var onClick: ((F) -> Void)?
  
  public let tableView: UITableView
  
  public var selectableItems: [SelectableItem<F>] = []
  public var filterPresenter: FilterPresenter?
  
  let cellID: String
  
  public init(tableView: UITableView, cellID: String = "FilterListFacet") {
    self.tableView = tableView
    self.cellID = cellID
    super.init()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  open func setSelectableItems(selectableItems: [(item: F, isSelected: Bool)]) {
    self.selectableItems = selectableItems
  }
  
  open func reload() {
    tableView.reloadData()
  }
  
  // MARK: - UITableViewDataSource
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectableItems.count
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    let filter = selectableItems[indexPath.row]
    let filterPresenter = self.filterPresenter ?? DefaultPresenter.Filter.present
    cell.textLabel?.text = filterPresenter(Filter(filter.item))
    cell.accessoryType = filter.isSelected ? .checkmark : .none
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onClick?(selectableItems[indexPath.row].item)
  }
  
}

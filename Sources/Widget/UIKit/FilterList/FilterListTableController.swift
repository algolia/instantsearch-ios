//
//  FilterListTableController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import InstantSearchCore
import UIKit

open class FilterListTableController<F: FilterType>: NSObject, FilterListController, UITableViewDataSource, UITableViewDelegate {
  
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
  
  // MARK: - FilterListController
  
  open func setSelectableItems(selectableItems: [SelectableItem<F>]) {
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
    let selectableItem = selectableItems[indexPath.row]
    onClick?(selectableItem.item)
  }
  
}

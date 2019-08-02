//
//  FacetListTableController.swift
//  InstantSearch
//
//  Created by Guy Daher on 22/07/2019.
//

import Foundation
@_exported import InstantSearchCore
import UIKit

open class FacetListTableController: NSObject, FacetListController {
  
  open var onClick: ((Facet) -> Void)?
  
  public let tableView: UITableView
  
  public var selectableItems: [SelectableItem<Facet>] = []
  public var facetPresenter: FacetPresenter?
  
  let cellID: String
  
  public init(tableView: UITableView, cellID: String = "FacetList") {
    self.tableView = tableView
    self.cellID = cellID
    super.init()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  // MARK: - RefinementFacetsViewController
  
  public func setSelectableItems(selectableItems: [SelectableItem<Facet>]) {
    self.selectableItems = selectableItems
  }
  
  public func reload() {
    tableView.reloadData()
  }
  
}

extension FacetListTableController: UITableViewDataSource {
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectableItems.count
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    let selectableRefinement = selectableItems[indexPath.row]
    let facetPresenter = self.facetPresenter ?? DefaultPresenter.Facet.present
    cell.textLabel?.text = facetPresenter(selectableRefinement.item)
    cell.accessoryType = selectableRefinement.isSelected ? .checkmark : .none
    
    return cell
  }
  
}

extension FacetListTableController: UITableViewDelegate {
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectableItem = selectableItems[indexPath.row]
    self.onClick?(selectableItem.item)
  }
  
}

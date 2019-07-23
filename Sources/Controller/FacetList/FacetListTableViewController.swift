//
//  FacetListViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 22/07/2019.
//

import Foundation
import InstantSearchCore
import UIKit

open class FacetListTableViewController: NSObject, FacetListController {

  public var onClick: ((Facet) -> Void)?

  public var tableView: UITableView

  var selectableItems: [RefinementFacet] = []
  var cellID: String

  public init(tableView: UITableView, cellID: String = "FacetList") {
    self.tableView = tableView
    self.cellID = cellID
    super.init()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    tableView.dataSource = self
    tableView.delegate = self
  }

  // MARK: RefinementFacetsViewController protocol

  public func setSelectableItems(selectableItems: [RefinementFacet]) {
    self.selectableItems = selectableItems
  }

  public func reload() {
    tableView.reloadData()
  }

}

extension FacetListTableViewController: UITableViewDataSource {

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectableItems.count
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

    let selectableRefinement: RefinementFacet = selectableItems[indexPath.row]

    let facetAttributedString = NSMutableAttributedString(string: selectableRefinement.item.value)
    let facetCountStringColor = [NSAttributedString.Key.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 14)]
    let facetCountString = NSAttributedString(string: " (\(selectableRefinement.item.count))", attributes: facetCountStringColor)
    facetAttributedString.append(facetCountString)

    cell.textLabel?.attributedText = facetAttributedString

    cell.accessoryType = selectableRefinement.isSelected ? .checkmark : .none

    return cell
  }

}

extension FacetListTableViewController: UITableViewDelegate {

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectableItem = selectableItems[indexPath.row]

    self.onClick?(selectableItem.item)
  }

}

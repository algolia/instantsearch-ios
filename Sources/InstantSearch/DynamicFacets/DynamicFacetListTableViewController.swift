//
//  DynamicFacetListTableViewController.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

/// Table view controller presenting ordered facets and ordered facet values
/// Each facet and corresponding values are represented as a table view section
public class DynamicFacetListTableViewController: UITableViewController, DynamicFacetListController {

  /// List of ordered facets with their attributes
  public var orderedFacets: [AttributedFacets]

  /// Set of selected facet values per attribute
  public var selections: [Attribute: Set<String>]

  // MARK: - DynamicFacetListController

  public var didSelect: ((Attribute, Facet) -> Void)?

  public func setSelections(_ selections: [Attribute: Set<String>]) {
    self.selections = selections
    tableView.reloadData()
  }

  public func setOrderedFacets(_ orderedFacets: [AttributedFacets]) {
    self.orderedFacets = orderedFacets
    tableView.reloadData()
  }

  /**
   - parameters:
     - orderedFacets: List of ordered facets with their attributes
     - selections: Set of selected facet values per attribute
  */
  public init(orderedFacets: [AttributedFacets] = [],
              selections: [Attribute: Set<String>] = [:]) {
    self.orderedFacets = orderedFacets
    self.selections = selections
    super.init(style: .plain)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  // MARK: - UITableViewDataSource

  public override func numberOfSections(in tableView: UITableView) -> Int {
    return orderedFacets.count
  }

  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderedFacets[section].facets.count
  }

  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  }

  // MARK: - UITableViewDelegate

  public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return orderedFacets[section].attribute.rawValue
  }

  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let attribute = orderedFacets[indexPath.section].attribute
    let facet = orderedFacets[indexPath.section].facets[indexPath.row]
    cell.textLabel?.text = facet.description
    cell.accessoryType = (selections[attribute]?.contains(facet.value) ?? false) ? .checkmark : .none
  }

  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let unit = orderedFacets[indexPath.section]
    let facet = unit.facets[indexPath.row]
    didSelect?(unit.attribute, facet)
  }

}
#endif

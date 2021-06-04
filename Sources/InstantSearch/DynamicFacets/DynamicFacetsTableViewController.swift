//
//  DynamicFacetsTableViewController.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public class DynamicFacetsTableViewController: UITableViewController, DynamicFacetsController {
  
  public var facetOrder: [AttributedFacets]
  public var selections: [Attribute: Set<String>]
  public var didSelect: ((Attribute, Facet) -> Void)?
    
  public func apply(_ selections: [Attribute : Set<String>]) {
    self.selections = selections
    tableView.reloadData()
  }
  
  public func apply(_ facetOrder: [AttributedFacets]) {
    self.facetOrder = facetOrder
    tableView.reloadData()
  }
  
  public init(facetOrder: [AttributedFacets] = [], selections: [Attribute: Set<String>] = [:]) {
    self.facetOrder = facetOrder
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
  public override func numberOfSections(in tableView: UITableView) -> Int {
    return facetOrder.count
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return facetOrder[section].facets.count
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  }
  
  public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return facetOrder[section].attribute.rawValue
  }
  
  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let attribute = facetOrder[indexPath.section].attribute
    let facet = facetOrder[indexPath.section].facets[indexPath.row]
    cell.textLabel?.text = facet.description
    cell.accessoryType = (selections[attribute]?.contains(facet.value) ?? false) ? .checkmark : .none
  }
  
  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let unit = facetOrder[indexPath.section]
    let facet = unit.facets[indexPath.row]
    didSelect?(unit.attribute, facet)
  }
  
}
#endif

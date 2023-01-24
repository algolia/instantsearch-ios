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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource

    override public func numberOfSections(in _: UITableView) -> Int {
      return orderedFacets.count
    }

    override public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
      return orderedFacets[section].facets.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }

    // MARK: - UITableViewDelegate

    override public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
      return orderedFacets[section].attribute.rawValue
    }

    override public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      let attribute = orderedFacets[indexPath.section].attribute
      let facet = orderedFacets[indexPath.section].facets[indexPath.row]
      cell.textLabel?.text = facet.description
      cell.accessoryType = (selections[attribute]?.contains(facet.value) ?? false) ? .checkmark : .none
    }

    override public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
      let unit = orderedFacets[indexPath.section]
      let facet = unit.facets[indexPath.row]
      didSelect?(unit.attribute, facet)
    }
  }
#endif

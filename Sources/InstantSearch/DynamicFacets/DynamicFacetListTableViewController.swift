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
  
  var expandedSections: Set<Int> = []
  
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
    orderedFacets.count
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    expandedSections.contains(section) ? orderedFacets[section].facets.count : 0
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  }
  
  // MARK: - UITableViewDelegate
  
//  public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return orderedFacets[section].attribute.rawValue
//  }
  
  public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let titleLabel = UILabel()
    titleLabel.textColor = .darkGray
    titleLabel.text = orderedFacets[section].attribute.rawValue
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let spacer = UIView()
    spacer.translatesAutoresizingMaskIntoConstraints = false
    
    let button = UIButton()
    button.tag = section
    button.tintColor = .darkGray
    button.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 13.0, *) {
      button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
      button.setImage(UIImage(systemName: "chevron.down"), for: .selected)
    }
    button.addTarget(self,
                     action: #selector(self.toggleSection(sender:)),
                     for: .touchUpInside)
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(spacer)
    stackView.addArrangedSubview(button)
    
    let container = UIView()
    container.backgroundColor = UIColor(red: 239/255, green: 240/255, blue: 240/255, alpha: 1)
    container.addSubview(stackView)
    container.addConstraints([
      container.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -14),
      container.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      container.topAnchor.constraint(equalTo: stackView.topAnchor),
      container.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 14),
    ])
    
    return container
  }
  
  @objc
  private func toggleSection(sender: UIButton) {
    let section = sender.tag
    
    let indexPathsForSection = (0..<orderedFacets[section].facets.count).map { IndexPath(row: $0, section: section) }
    
    if expandedSections.contains(section) {
      sender.isSelected = false
      expandedSections.remove(section)
      tableView.deleteRows(at: indexPathsForSection, with: .fade)
    } else {
      sender.isSelected = true
      expandedSections.insert(section)
      tableView.insertRows(at: indexPathsForSection, with: .fade)
    }

  }
  
  public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    30
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

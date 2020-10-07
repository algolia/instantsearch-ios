//
//  HierarchicalGroupAccessor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 12/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Provides a convenient interface to a hierarchical group contained by FilterState
public struct HierarchicalGroupAccessor: SpecializedGroupAccessor {

  public typealias Filter = FacetFilter

  let groupID: FilterGroup.ID
  var filtersContainer: FiltersContainer

  public var isEmpty: Bool {
    return filtersContainer.filters.isEmpty
  }

  var hierarchicalAttributes: [Attribute] {
    return filtersContainer.filters.hierarchicalAttributes(forGroupWithName: groupID.name)
  }

  var hierarchicalFilters: [Filter] {
    return filtersContainer.filters.hierarchicalFilters(forGroupWithName: groupID.name)
  }

  func set(_ hierarchicalAttributes: [Attribute]) {
    filtersContainer.filters.set(hierarchicalAttributes, forGroupWithName: groupID.name)
  }

  func set(_ hierarchicalFilters: [Filter]) {
    filtersContainer.filters.set(hierarchicalFilters, forGroupWithName: groupID.name)
  }

  init(filtersContainer: FiltersContainer, groupName: String) {
    self.filtersContainer = filtersContainer
    self.groupID = .hierarchical(name: groupName)
  }

  /// Adds filter to group
  /// - parameter filter: filter to add
  public func add(_ filters: Filter...) {
    filtersContainer.filters.addAll(filters: filters, toGroupWithID: groupID)
  }

  /// Adds the filters of a sequence to group
  /// - parameter filters: sequence of filters to add
  public func addAll<S: Sequence>(_ filters: S) where S.Element == Filter {
    filtersContainer.filters.addAll(filters: filters.map { $0 as FilterType }, toGroupWithID: groupID)
  }

  /// Tests whether group contains a filter
  /// - parameter filter: sought filter
  public func contains(_ filter: Filter) -> Bool {
    return filtersContainer.filters.contains(filter, inGroupWithID: groupID)
  }

  /// Removes all filters with specified attribute from group
  /// - parameter attribute: specified attribute
  public func removeAll(for attribute: Attribute) {
    return filtersContainer.filters.removeAll(for: attribute, fromGroupWithID: groupID)
  }

  /// Removes filter from group
  /// - parameter filter: filter to remove
  public func remove(_ filter: Filter) {
    filtersContainer.filters.remove(filter, fromGroupWithID: groupID)
  }

  /// Removes a sequence of filters from group
  /// - parameter filters: sequence of filters to remove
  @discardableResult public func removeAll<S: Sequence>(_ filters: S) -> Bool where S.Element == Filter {
    filtersContainer.filters.removeAll(fromGroupWithID: groupID)
    return false
  }

  /// Removes all filters in group
  public func removeAll() {
    filtersContainer.filters.removeAll(fromGroupWithID: groupID)
  }

  /// Removes all filters in other all groups
  public func removeAllOthers() {
    filtersContainer.filters.removeAllExcept([groupID])
  }

  /// Removes filter from group if contained by it, otherwise adds filter to group
  /// - parameter filter: filter to toggle
  public func toggle(_ filter: Filter) {
    filtersContainer.filters.toggle(filter, inGroupWithID: groupID)
  }

  public func filters(for attribute: Attribute) -> [Filter] {
    return filtersContainer.filters.getFilters(for: attribute).compactMap { $0.filter as? Filter }
  }

  public func filters() -> [Filter] {
    return filtersContainer.filters.getFilters().compactMap { $0.filter as? Filter }
  }

}

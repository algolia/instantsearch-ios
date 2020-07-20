//
//  OrGroupAccessor.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 24/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Provides a convenient interface to a disjunctive group contained by FilterState
public struct OrGroupAccessor<Filter: FilterType>: SpecializedGroupAccessor {

    let filtersContainer: FiltersContainer
    let groupID: FilterGroup.ID

    /// A Boolean value indicating whether group contains at least on filter
    public var isEmpty: Bool {
      return filtersContainer.filters.getFilters(forGroupWithID: groupID).isEmpty
    }

    init(filtersContainer: FiltersContainer, groupName: String) {
      self.filtersContainer = filtersContainer
      let filterType = FilterGroup.ID.Filter(Filter.self)!
      self.groupID = .or(name: groupName, filterType: filterType)
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

    public func remove(_ filter: Filter) {
        _ = filtersContainer.filters.remove(filter, fromGroupWithID: groupID)
    }

    /// Removes a sequence of filters from group
    /// - parameter filters: sequence of filters to remove
    @discardableResult public func removeAll<S: Sequence>(_ filters: S) -> Bool where S.Element == Filter {
        return filtersContainer.filters.removeAll(filters.map { $0 as FilterType }, fromGroupWithID: groupID)
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
    /// - parameter filter: filter to toggleE
    public func toggle(_ filter: Filter) {
        filtersContainer.filters.toggle(filter, inGroupWithID: groupID)
    }

    public func filters(for attribute: Attribute) -> [Filter] {
      return filtersContainer.filters.getFilters(forGroupWithID: groupID).filter { $0.attribute == attribute }.compactMap { $0.filter as? Filter }
    }

    public func filters() -> [Filter] {
      return filtersContainer.filters.getFilters(forGroupWithID: groupID).compactMap { $0.filter as? Filter }
    }

}

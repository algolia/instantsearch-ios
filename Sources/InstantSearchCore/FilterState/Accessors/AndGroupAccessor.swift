//
//  AndGroupAccessor.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 24/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Provides a convenient interface to a conjunctive group contained by FilterState
public struct AndGroupAccessor: GroupAccessor {

    let filtersContainer: FiltersContainer
    let groupID: FilterGroup.ID

    /// A Boolean value indicating whether group contains at least on filter
    public var isEmpty: Bool {
      return filtersContainer.filters.getFilters(forGroupWithID: groupID).isEmpty
    }

    init(filtersContainer: FiltersContainer, groupName: String) {
        self.filtersContainer = filtersContainer
        self.groupID = .and(name: groupName)
    }

    /// Adds filter to group
    /// - parameter filter: filter to add
    public func add(_ filters: FilterType...) {
        filtersContainer.filters.addAll(filters: filters, toGroupWithID: groupID)
    }

    /// Adds the filters of a sequence to group
    /// - parameter filters: sequence of filters to add
    public func addAll(_ filters: [FilterType]) {
        filtersContainer.filters.addAll(filters: filters, toGroupWithID: groupID)
    }

    /// Tests whether group contains a filter
    /// - parameter filter: sought filter
    public func contains<T: FilterType>(_ filter: T) -> Bool {
        return filtersContainer.filters.contains(filter, inGroupWithID: groupID)
    }

    /// Removes all filters with specified attribute from group
    /// - parameter attribute: specified attribute
    public func removeAll(for attribute: Attribute) {
        return filtersContainer.filters.removeAll(for: attribute, fromGroupWithID: groupID)
    }

    /// Removes filter from group
    /// - parameter filter: filter to remove
    @discardableResult public func remove<T: FilterType>(_ filter: T) -> Bool {
        return filtersContainer.filters.remove(filter, fromGroupWithID: groupID)
    }

    /// Removes a sequence of filters from group
    /// - parameter filters: sequence of filters to remove
    @discardableResult public func removeAll<S: Sequence>(_ filters: S) -> Bool where S.Element == FilterType {
        return filtersContainer.filters.removeAll(filters, fromGroupWithID: groupID)
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
    public func toggle<T: FilterType>(_ filter: T) {
        filtersContainer.filters.toggle(filter, inGroupWithID: groupID)
    }

}

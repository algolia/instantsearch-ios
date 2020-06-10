//
//  SpecializedAndGroupAccessor.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 26/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Provides a convenient interface to a conjunctive group contained by FilterState specialized for filters of concrete type
public struct SpecializedAndGroupAccessor<Filter: FilterType>: SpecializedGroupAccessor {

    private var genericAccessor: AndGroupAccessor

    var filtersContainer: FiltersContainer {
      return genericAccessor.filtersContainer
    }

    public var groupID: FilterGroup.ID {
        return genericAccessor.groupID
    }

    /// A Boolean value indicating whether group contains at least on filter
    public var isEmpty: Bool {
        return genericAccessor.isEmpty
    }

    init(_ genericAccessor: AndGroupAccessor) {
        self.genericAccessor = genericAccessor
    }

    /// Adds filter to group
    /// - parameter filter: filter to add
    public func add(_ filters: Filter...) {
      genericAccessor.addAll(filters)
    }

    /// Adds the filters of a sequence to group
    /// - parameter filters: sequence of filters to add
    public func addAll<S: Sequence>(_ filters: S) where S.Element == Filter {
      genericAccessor.addAll(filters.map { $0 as FilterType })
    }

    /// Tests whether group contains a filter
    /// - parameter filter: sought filter
    public func contains(_ filter: Filter) -> Bool {
        return genericAccessor.contains(filter)
    }

    /// Removes all filters with specified attribute from group
    /// - parameter attribute: specified attribute
    public func removeAll(for attribute: Attribute) {
        return genericAccessor.removeAll(for: attribute)
    }

    /// Removes filter from group
    /// - parameter filter: filter to remove
    public func remove(_ filter: Filter) {
        genericAccessor.remove(filter)
    }

    /// Removes a sequence of filters from group
    /// - parameter filters: sequence of filters to remove
    @discardableResult public func removeAll<S: Sequence>(_ filters: S) -> Bool where S.Element == Filter {
        return genericAccessor.removeAll(filters.map { $0 as FilterType })
    }

    /// Removes all filters in group
    public func removeAll() {
        genericAccessor.removeAll()
    }

    /// Removes all filters in other all groups
    public func removeAllOthers() {
      genericAccessor.removeAllOthers()
    }

    /// Removes filter from group if contained by it, otherwise adds filter to group
    /// - parameter filter: filter to toggle
    public func toggle(_ filter: Filter) {
        genericAccessor.toggle(filter)
    }

    public func filters(for attribute: Attribute) -> [Filter] {
      return filtersContainer.filters.getFilters(forGroupWithID: groupID).filter { $0.attribute == attribute }.compactMap { $0.filter as? Filter }
    }

    public func filters() -> [Filter] {
      return filtersContainer.filters.getFilters(forGroupWithID: groupID).compactMap { $0.filter as? Filter }
    }

}

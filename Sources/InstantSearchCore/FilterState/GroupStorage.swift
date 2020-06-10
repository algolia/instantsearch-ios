//
//  GroupStorage.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 15/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

struct GroupsStorage {

  var filterGroups: [FilterGroup.ID: FilterGroupType]

  init() {
    filterGroups = [:]
  }

}

extension GroupsStorage: FilterGroupsConvertible {

  func toFilterGroups() -> [FilterGroupType] {

    let filterComparator: (FilterType, FilterType) -> Bool = {
      let converter = FilterConverter()
      let lhsString = converter.sql($0)!
      let rhsString = converter.sql($1)!
      return lhsString < rhsString
    }

    let groupIDComparator: (FilterGroup.ID, FilterGroup.ID) -> Bool = {
      guard $0.name != $1.name else {
        switch ($0, $1) {
        case (.or, .and):
          return true
        default:
          return false
        }
      }
      return $0.name < $1.name
    }

    let transform: (FilterGroup.ID, FilterGroupType) -> FilterGroupType = { (groupID, filterGroup) in

      let sortedFilters = filterGroup.filters.sorted(by: filterComparator)

      switch groupID {
      case .and:
        return FilterGroup.And(filters: sortedFilters, name: groupID.name)
      case .hierarchical:
        return FilterGroup.And(filters: sortedFilters.compactMap { $0 as? Filter.Facet }, name: groupID.name)
      case .or(_, .facet):
        return FilterGroup.Or(filters: sortedFilters.compactMap { $0 as? Filter.Facet }, name: groupID.name)
      case .or(_, .tag):
        return FilterGroup.Or(filters: sortedFilters.compactMap { $0 as? Filter.Tag }, name: groupID.name)
      case .or(_, .numeric):
        return FilterGroup.Or(filters: sortedFilters.compactMap { $0 as? Filter.Numeric }, name: groupID.name)
      }

    }

    return filterGroups
      .sorted(by: { groupIDComparator($0.key, $1.key) })
      .compactMap(transform)
      .filter { !$0.filters.isEmpty }

  }

}

extension GroupsStorage: FiltersReadable {

  func getFilters(forGroupWithID groupID: FilterGroup.ID) -> Set<Filter> {
    return Set(filterGroups[groupID]?.filters.map(Filter.init) ?? [])
  }

  func getFilters(for attribute: Attribute) -> Set<Filter> {
    return Set(getFilters().filter { $0.attribute == attribute })
  }

  func getFiltersAndID() -> Set<FilterAndID> {
    return Set(filterGroups
      .map { (id, group) in group.filters.map { (id, $0)  } }
      .flatMap { $0 }
      .map { FilterAndID(filter: Filter($0.1), id: $0.0) })
  }

  func getFilters() -> Set<Filter> {
    return Set(filterGroups.values.flatMap { $0.filters }.map(Filter.init))
  }

  var isEmpty: Bool {
    return filterGroups.values.allSatisfy { $0.filters.isEmpty }
  }

  func contains(_ filter: FilterType, inGroupWithID groupID: FilterGroup.ID) -> Bool {
    return filterGroups[groupID]?.contains(filter) == true
  }

  func getGroupIDs() -> Set<FilterGroup.ID> {
    return Set(filterGroups.keys)
  }

}

extension GroupsStorage: FiltersWritable {

  private func emptyGroup(with filterGroupID: FilterGroup.ID) -> FilterGroupType {
    switch filterGroupID {
    case .and(name: let name):
      return FilterGroup.And(filters: [], name: name)
    case .hierarchical(name: let name):
      return FilterGroup.Hierarchical(filters: [], name: name)
    case .or(name: let name, filterType: .facet):
      return FilterGroup.Or<Filter.Facet>(filters: [], name: name)
    case .or(name: let name, filterType: .numeric):
      return FilterGroup.Or<Filter.Numeric>(filters: [], name: name)
    case .or(name: let name, filterType: .tag):
      return FilterGroup.Or<Filter.Tag>(filters: [], name: name)
    }
  }

  mutating func addAll<S: Sequence>(filters: S, toGroupWithID groupID: FilterGroup.ID) where S.Element == FilterType {
    let group = filterGroups[groupID] ?? emptyGroup(with: groupID)
    let updatedFilters = Set(group.filters.map(Filter.init)).union(filters.map(Filter.init)).map { $0.filter }
    filterGroups[groupID] = group.withFilters(updatedFilters)
  }

  @discardableResult mutating func removeAll<S: Sequence>(_ filters: S, fromGroupWithID groupID: FilterGroup.ID) -> Bool where S.Element == FilterType {
    guard let existingGroup = filterGroups[groupID] else {
      return false
    }

    let filtersToRemove = filters.map(Filter.init)
    let updatedFilters = existingGroup.filters.filter { !filtersToRemove.contains(Filter($0))  }
    let updatedGroup = existingGroup.withFilters(updatedFilters)
    if updatedGroup.isEmpty {
      filterGroups.removeValue(forKey: groupID)
    } else {
      filterGroups[groupID] = updatedGroup
    }
    return existingGroup.filters.count > updatedFilters.count
  }

  mutating func removeAll(fromGroupWithIDs groupIDs: [FilterGroup.ID]) {
    for groupID in groupIDs {
      switch groupID {
      case .hierarchical:
        filterGroups[groupID] = filterGroups[groupID]?.withFilters([])
      default:
        filterGroups.removeValue(forKey: groupID)
      }
    }
  }

  @discardableResult mutating func removeAll<S: Sequence>(_ filters: S) -> Bool where S.Element == FilterType {
    var wasRemoved = false
    let filtersToRemove = Set(filters.map(Filter.init))
    for (id, group) in filterGroups {
      let updatedFilters = group.filters.filter { !filtersToRemove.contains(Filter($0)) }
      filterGroups[id] = group.withFilters(updatedFilters)
      wasRemoved = wasRemoved || updatedFilters.count < group.filters.count
    }
    return wasRemoved
  }

  mutating func removeAll(for attribute: Attribute, fromGroupWithID groupID: FilterGroup.ID) {
    guard let existingGroup = filterGroups[groupID] else {
      return
    }

    let updatedFilters = existingGroup.filters.filter { $0.attribute != attribute }
    filterGroups[groupID] = existingGroup.withFilters(updatedFilters)
  }

  mutating func removeAll(for attribute: Attribute) {
    for (groupID, group) in filterGroups {
      let updatedFilters = group.filters.filter { $0.attribute != attribute }
      filterGroups[groupID] = group.withFilters(updatedFilters)
    }
  }

  mutating func removeAll() {
    filterGroups.removeAll()
  }

}

extension GroupsStorage: HierarchicalManageable {

  func hierarchicalGroup(withName groupName: String) -> FilterGroup.Hierarchical? {
    return filterGroups[.hierarchical(name: groupName)].flatMap { $0 as? FilterGroup.Hierarchical }
  }

  func hierarchicalAttributes(forGroupWithName groupName: String) -> [Attribute] {
    return hierarchicalGroup(withName: groupName)?.hierarchicalAttributes ?? []
  }

  func hierarchicalFilters(forGroupWithName groupName: String) -> [Filter.Facet] {
    return hierarchicalGroup(withName: groupName)?.hierarchicalFilters ?? []

  }

  mutating func set(_ hierarchicalAttributes: [Attribute], forGroupWithName groupName: String) {
    let groupID: FilterGroup.ID = .hierarchical(name: groupName)
    var updatedGroup: FilterGroup.Hierarchical = (filterGroups[groupID] as? FilterGroup.Hierarchical) ?? .init(filters: [], name: groupName)
    updatedGroup.hierarchicalAttributes = hierarchicalAttributes
    filterGroups[groupID] = updatedGroup
  }

  mutating func set(_ hierarchicalFilters: [Filter.Facet], forGroupWithName groupName: String) {
    let groupID: FilterGroup.ID = .hierarchical(name: groupName)
    var updatedGroup: FilterGroup.Hierarchical = (filterGroups[groupID] as? FilterGroup.Hierarchical) ?? .init(filters: [], name: groupName)
    updatedGroup.hierarchicalFilters = hierarchicalFilters
    filterGroups[groupID] = updatedGroup
  }

}

extension GroupsStorage {

  /// Returns a set of attributes suitable for disjunctive faceting
  func getDisjunctiveFacetsAttributes() -> Set<Attribute> {
    let attributes = filterGroups
      .values
      .filter { $0.isDisjuncitve }
      .compactMap { $0.filters.compactMap { $0 as? Filter.Facet } }
      .flatMap { $0 }
      .map { $0.attribute }
    return Set(attributes)

  }

  /// Returns a dictionary of all facet filters with their associated values
  func getFacetFilters() -> [Attribute: Set<Filter.Facet.ValueType>] {
    let facetFilters: [Filter.Facet] = filterGroups.values.flatMap { $0.filters.compactMap { $0 as? Filter.Facet } }

    var refinements: [Attribute: Set<Filter.Facet.ValueType>] = [:]
    for filter in facetFilters {
      let existingValues = refinements[filter.attribute, default: []]
      let updatedValues = existingValues.union([filter.value])
      refinements[filter.attribute] = updatedValues
    }
    return refinements
  }

  /// Returns a raw representaton of all facet filters with their associated values
  func getRawFacetFilters() -> [String: [String]] {
    return getFacetFilters()
      .map { ($0.key.rawValue, $0.value.map { $0.description }) }
      .reduce([String: [String]]()) { (refinements, arg1) in
        let (attribute, values) = arg1
        return refinements.merging([attribute: values], uniquingKeysWith: { (_, new) -> [String] in
          new
        })
    }
  }

}

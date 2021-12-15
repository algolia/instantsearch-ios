//
//  FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 18/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/**
 Encapsulates search filters providing a convenient interface to manage them
 */
public class FilterState {

  typealias Storage = FiltersReadable & FiltersWritable & FilterGroupsConvertible & HierarchicalManageable

  /// Filters container
  var filters: Storage

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query and error
  public var onChange: Observer<ReadOnlyFiltersContainer>

  /// Default constructor
  public init() {
    self.filters = GroupsStorage()
    self.onChange = .init()
    Telemetry.shared.trace(type: .filterState)
  }

  /// Copy constructor
  public init(_ filterState: FilterState) {
    self.filters = filterState.filters
    self.onChange = .init()
    Telemetry.shared.trace(type: .filterState, parameters: .filterState)
  }

  /// Replace the groups of filter state by the groups of the filter state passed as parameter
  /// - Parameter filterState: source filter state
  public func setWithContent(of filterState: FilterState) {
    self.filters = filterState.filters
  }

  /// Force trigger onChange event
  public func notifyChange() {
    onChange.fire(ReadOnlyFiltersContainer(filterState: self))
  }

  /// Subscript providing access to a conjunctive group with specified name
  /// - Parameter groupName: required group name
  /// - Returns: required group accessor
  public subscript(and groupName: String) -> AndGroupAccessor {
    return .init(filtersContainer: self, groupName: groupName)
  }

  /// Subscript providing access to disjunctive group with specified name and manually defined filter type
  /// To use if filter type cannot be inferred
  /// - Parameter groupName: required group name
  /// - Returns: required group accessor
  public subscript<F: FilterType>(or groupName: String, type: F.Type) -> OrGroupAccessor<F> {
    return .init(filtersContainer: self, groupName: groupName)
  }

  /// Subscript providing access to a disjunctive group with specified name
  /// - Parameter groupName: required group name
  /// - Returns: required group accessor
  public subscript<F: FilterType>(or groupName: String) -> OrGroupAccessor<F> {
    return .init(filtersContainer: self, groupName: groupName)
  }

  /// Subscript providing access to a hierarchical group with specified name
  /// - Parameter groupName: required group name
  /// - Returns: required group accessor
  public subscript(hierarchical groupName: String) -> HierarchicalGroupAccessor {
    return .init(filtersContainer: self, groupName: groupName)
  }

}

extension FilterState: FiltersContainer {}

extension FilterState: FilterGroupsConvertible {

  public func toFilterGroups() -> [FilterGroupType] {
    return filters.toFilterGroups()
  }

}

extension FilterState: CustomStringConvertible {

  public var description: String {
    return FilterGroupConverter().sql(toFilterGroups()) ?? ""
  }

}

extension FilterState: CustomDebugStringConvertible {

  public var debugDescription: String {
    let filterGroups = toFilterGroups()
    guard !filterGroups.isEmpty else {
      return "FilterState {}"
    }
    let body = filterGroups.map { group in
      let groupName = (group.name ?? "")
      let filtersDescription = FilterGroupConverter().sql(group) ?? ""
      return " \"\(groupName)\": \(filtersDescription)"
    }.joined(separator: "\n")
    return "FilterState {\n\(body)\n}"
  }

}

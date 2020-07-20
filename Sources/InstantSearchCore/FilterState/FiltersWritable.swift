//
//  FiltersWritable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 16/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

protocol FiltersWritable {

  /// Adds filter to a specified group
  /// - parameter filter: filter to add
  /// - parameter groupID: target group ID

  mutating func add(_ filter: FilterType, toGroupWithID groupID: FilterGroup.ID)

  /// Adds a sequence of filters to a specified group
  /// - parameter filters: sequence of filters to add
  /// - parameter groupID: target group ID

  mutating func addAll<S: Sequence>(filters: S, toGroupWithID groupID: FilterGroup.ID) where S.Element == FilterType

  /// Removes filter from a specified group
  /// - parameter filter: filter to remove
  /// - parameter groupID: target group ID
  /// - returns: true if removal succeeded, otherwise returns false

  @discardableResult mutating func remove(_ filter: FilterType, fromGroupWithID groupID: FilterGroup.ID) -> Bool

  /// Removes a sequence of filters from a specified group
  /// - parameter filters: sequence of filters to remove
  /// - parameter groupID: target group ID
  /// - returns: true if at least one filter in filters sequence is contained by a specified group and so has been removed, otherwise returns false

  @discardableResult mutating func removeAll<S: Sequence>(_ filters: S, fromGroupWithID groupID: FilterGroup.ID) -> Bool where S.Element == FilterType

  /// Removes all filters from a specifed group
  /// - parameter group: target group ID

  mutating func removeAll(fromGroupWithID groupID: FilterGroup.ID)

  mutating func removeAll(fromGroupWithIDs groupIDs: [FilterGroup.ID])

  /// Removes filter from all the groups
  /// - parameter filter: filter to remove
  /// - returns: true if specified filter has been removed from at least one group, otherwise returns false

  @discardableResult mutating func remove(_ filter: FilterType) -> Bool

  /// Removes a sequence of filters from all the groups
  /// - parameter filters: sequence of filters to remove

  mutating func removeAll<S: Sequence>(_ filters: S) -> Bool where S.Element == FilterType

  /// Removes all filters with specified attribute in a specified group
  /// - parameter attribute: target attribute
  /// - parameter groupID: target group ID

  mutating func removeAll(for attribute: Attribute, fromGroupWithID groupID: FilterGroup.ID)

  /// Removes all filters with specified attribute in all the groups
  /// - parameter attribute: target attribute

  mutating func removeAll(for attribute: Attribute)

  /// Removes all filters from all the groups

  mutating func removeAll()

  /// Removes filter from group if contained by it, otherwise adds filter to group
  /// - parameter filter: filter to toggle
  /// - parameter groupID: target group ID

  mutating func toggle(_ filter: FilterType, inGroupWithID groupID: FilterGroup.ID)

  /// Toggles a sequence of filters in group
  /// - parameter filters: sequence of filters to toggle
  /// - parameter groupID: target group ID

  mutating func toggle<S: Sequence>(_ filters: S, inGroupWithID groupID: FilterGroup.ID) where S.Element == FilterType

}

extension FiltersWritable {

  mutating func add(_ filter: FilterType, toGroupWithID groupID: FilterGroup.ID) {
    addAll(filters: [filter], toGroupWithID: groupID)
  }

  @discardableResult mutating func remove(_ filter: FilterType, fromGroupWithID groupID: FilterGroup.ID) -> Bool {
    return removeAll([filter], fromGroupWithID: groupID)
  }

  @discardableResult mutating func remove(_ filter: FilterType) -> Bool {
    return removeAll([filter])
  }

  mutating func removeAll(fromGroupWithID groupID: FilterGroup.ID) {
    removeAll(fromGroupWithIDs: [groupID])
  }

  mutating func toggle(_ filter: FilterType, inGroupWithID groupID: FilterGroup.ID) {
    toggle([filter], inGroupWithID: groupID)
  }

}

extension FiltersWritable where Self: FiltersReadable {

  mutating func toggle<S: Sequence>(_ filters: S, inGroupWithID groupID: FilterGroup.ID) where S.Element == FilterType {
    for filter in filters {
      if contains(filter, inGroupWithID: groupID) {
        _ = remove(filter, fromGroupWithID: groupID)
      } else {
        add(filter, toGroupWithID: groupID)
      }
    }
  }

  mutating func removeAllExcept(_ groupIDsToKeep: [FilterGroup.ID]) {
    let groupIDsToRemove = getGroupIDs().filter { !groupIDsToKeep.contains($0) }
    removeAll(fromGroupWithIDs: Array(groupIDsToRemove))
  }

}

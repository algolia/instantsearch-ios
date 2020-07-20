//
//  FilterState+Commands.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 07/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

private protocol FilterStateCommand {

  func execute(on filterState: FilterState)

}

private extension FilterState {

  struct Add<T: FilterType>: FilterStateCommand {

    public let groupID: FilterGroup.ID
    public let filters: [T]

    public init(filter: T, groupID: FilterGroup.ID) {
      self.init(filters: [filter], groupID: groupID)
    }

    public init<S: Sequence>(filters: S, groupID: FilterGroup.ID) where S.Element == T {
      self.groupID = groupID
      self.filters = Array(filters)
    }

    public func execute(on filterState: FilterState) {
      filterState.addAll(filters: filters, toGroupWithID: groupID)
    }

  }

  struct Remove<T: FilterType>: FilterStateCommand {

    public let filters: [T]
    public let groupID: FilterGroup.ID?

    public init(filter: T, groupID: FilterGroup.ID? = nil) {
      self.init(filters: [filter], groupID: groupID)
    }

    public init(filters: [T], groupID: FilterGroup.ID? = nil) {
      self.groupID = groupID
      self.filters = filters
    }

    public func execute(on filterState: FilterState) {

      if let groupID = groupID {
        filterState.removeAll(filters, fromGroupWithID: groupID)
      } else {
        _ = filterState.removeAll(filters)
      }
    }

  }

  enum Clear: FilterStateCommand {

    case all
    case group(FilterGroup.ID)
    case attribute(Attribute)
    case attributeInGroup(Attribute, FilterGroup.ID)

    public func execute(on filterState: FilterState) {

      switch self {
      case .all:
        filterState.removeAll()
      case .attribute(let attribute):
        filterState.removeAll(for: attribute)
      case .attributeInGroup(let attribute, let groupID):
        filterState.removeAll(for: attribute, fromGroupWithID: groupID)
      case .group(let groupID):
        filterState.removeAll(fromGroupWithID: groupID)
      }

    }

  }

  struct Toggle<T: FilterType>: FilterStateCommand {

    public let groupID: FilterGroup.ID
    public let filters: [T]

    public init(filter: T, groupID: FilterGroup.ID) {
      self.init(filters: [filter], groupID: groupID)
    }

    public init(filters: [T], groupID: FilterGroup.ID) {
      self.groupID = groupID
      self.filters = filters
    }

    public func execute(on filterState: FilterState) {
      filterState.toggle(filters, inGroupWithID: groupID)
    }

  }

}

public extension FilterState {

  struct Command {

    fileprivate let command: FilterStateCommand

    public static func add<T: FilterType>(filter: T, toGroupWithID groupID: FilterGroup.ID) -> Command {
      return .init(command: FilterState.Add(filter: filter, groupID: groupID))
    }

    public static func add<T: FilterType, S: Sequence>(filters: S, toGroupWithID groupID: FilterGroup.ID) -> Command where S.Element == T {
      return .init(command: FilterState.Add(filters: filters, groupID: groupID))
    }

    public static func remove<T: FilterType>(filter: T, fromGroupWithID groupID: FilterGroup.ID) -> Command {
      return .init(command: FilterState.Remove(filter: filter, groupID: groupID))
    }

    public static func remove<T: FilterType>(filters: [T], fromGroupWithID groupID: FilterGroup.ID) -> Command {
      return .init(command: FilterState.Remove(filters: filters, groupID: groupID))
    }

    public static var removeAll: Command = .init(command: FilterState.Clear.all)

    public static func removeAll(fromGroupWithID groupID: FilterGroup.ID) -> Command {
      return .init(command: FilterState.Clear.group(groupID))
    }

    public static func removeAll(for attribute: Attribute, fromGroupWithID groupID: FilterGroup.ID? = nil) -> Command {
      return .init(command: FilterState.Clear.attribute(attribute))
    }

    public static func toggle<T: FilterType>(filter: T, toGroupWithID groupID: FilterGroup.ID) -> Command {
      return .init(command: FilterState.Toggle(filter: filter, groupID: groupID))
    }

    public static func toggle<T: FilterType>(filters: [T], toGroupWithID groupID: FilterGroup.ID) -> Command {
      return .init(command: FilterState.Toggle(filters: filters, groupID: groupID))
    }

  }

  func notify(_ commands: Command...) {
    commands.forEach { $0.command.execute(on: self) }
    onChange.fire(ReadOnlyFiltersContainer(filterState: self))
  }

}

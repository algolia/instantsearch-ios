//
//  FilterGroupID.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable type_name

import Foundation

public extension FilterGroup {
  enum ID: Hashable {
    public enum Filter {
      case facet, numeric, tag

      init?<F: FilterType>(_ filterType: F.Type) {
        switch filterType {
        case is FacetFilter.Type:
          self = .facet
        case is NumericFilter.Type:
          self = .numeric
        case is TagFilter.Type:
          self = .tag
        default:
          return nil
        }
      }
    }

    case or(name: String, filterType: Filter)
    case and(name: String)
    case hierarchical(name: String)

    var name: String {
      switch self {
      case let .or(name: name, _),
           let .and(name: name),
           let .hierarchical(name: name):
        return name
      }
    }

    var isConjunctive: Bool {
      switch self {
      case .and,
           .hierarchical:
        return true
      case .or:
        return false
      }
    }

    var isDisjunctive: Bool {
      return !isConjunctive
    }

    init?(_ filterGroup: FilterGroupType) {
      let groupName = filterGroup.name ?? ""
      switch filterGroup {
      case is FilterGroup.And:
        self = .and(name: groupName)
      case is FilterGroup.Hierarchical:
        self = .hierarchical(name: groupName)
      case is FilterGroup.Or<FacetFilter>:
        self = .or(name: groupName, filterType: .facet)
      case is FilterGroup.Or<NumericFilter>:
        self = .or(name: groupName, filterType: .numeric)
      case is FilterGroup.Or<TagFilter>:
        self = .or(name: groupName, filterType: .tag)
      default:
        return nil
      }
    }
  }
}

extension FilterGroup.ID: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .and(name: name):
      return "and<\(name)>"
    case let .or(name: name, _):
      return "or<\(name)>"
    case let .hierarchical(name: name):
      return "hierarchical<\(name)>"
    }
  }
}
// swiftlint:enable type_name

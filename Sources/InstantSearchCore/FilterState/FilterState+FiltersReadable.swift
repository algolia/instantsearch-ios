//
//  FilterState+FiltersReadable.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 19/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension FilterState: FiltersReadable {

  func getGroupIDs() -> Set<FilterGroup.ID> {
    return filters.getGroupIDs()
  }

  public var isEmpty: Bool {
    return filters.isEmpty
  }

  func contains(_ filter: FilterType, inGroupWithID groupID: FilterGroup.ID) -> Bool {
    return filters.contains(filter, inGroupWithID: groupID)
  }

  func getFilters(forGroupWithID groupID: FilterGroup.ID) -> Set<Filter> {
    return filters.getFilters(forGroupWithID: groupID)
  }

  public func getFilters(for attribute: Attribute) -> Set<Filter> {
    return filters.getFilters(for: attribute)
  }

  public func getFilters() -> Set<Filter> {
    return filters.getFilters()
  }

  public func getFiltersAndID() -> Set<FilterAndID> {
    return filters.getFiltersAndID()
  }

}

//
//  CurrentFiltersInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Business logic for Current Refinements component
public class CurrentFiltersInteractor: ItemsListInteractor<FilterAndID> {

  public override init(items: Set<FilterAndID> = []) {
    Telemetry.shared.trace(type: .currentFilters,
                           parameters: [
                            items.isEmpty ? .none : .items
                           ])
    super.init(items: items)
  }

}

/// Union of a filter and its group in a filter state
public struct FilterAndID: Hashable {

  /// Stored filter
  public let filter: Filter

  /// Identifier of a group in a filter state
  public let id: FilterGroup.ID

  public var text: String

  public init(filter: Filter, id: FilterGroup.ID, text: String = "") {
    self.filter = filter
    self.id = id
    self.text = text
  }
}

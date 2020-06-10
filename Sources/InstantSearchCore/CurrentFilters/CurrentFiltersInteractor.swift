//
//  CurrentFiltersInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias CurrentFiltersInteractor = ItemsListInteractor<FilterAndID>

public struct FilterAndID: Hashable {
  public let filter: Filter
  public let id: FilterGroup.ID
  public var text: String

  public init(filter: Filter, id: FilterGroup.ID, text: String = "") {
    self.filter = filter
    self.id = id
    self.text = text
  }
}

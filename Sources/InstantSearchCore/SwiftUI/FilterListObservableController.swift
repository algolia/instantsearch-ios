//
//  FilterListObservableController.swift
//  
//
//  Created by Vladislav Fitc on 10/06/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// FilterListController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class FilterListObservableController<Filter: FilterType & Hashable>: ObservableObject, SelectableListController {

  /// List of filters to present
  @Published public var filters: [Filter]

  /// Set of selected filters
  @Published public var selections: Set<Filter>

  public var onClick: ((Filter) -> Void)?

  /// Toggle filter selection
  public func toggle(_ filter: Filter) {
    onClick?(filter)
  }

  /// Returns a bool value indicating whether the provided filter is selected
  public func isSelected(_ filter: Filter) -> Bool {
    return selections.contains(filter)
  }

  public func setSelectableItems(selectableItems: [SelectableItem<Filter>]) {
    self.filters = selectableItems.map(\.item)
    self.selections = Set(selectableItems.filter(\.isSelected).map(\.item))
  }

  public func reload() {
    objectWillChange.send()
  }

  /**
   - parameters:
     - filters: List of filters to present
     - selections: Set of selected filters
     - onClick: Action triggered on interaction with filter
   */
  public init(filters: [Filter] = [],
              selections: Set<Filter> = [],
              onClick: ((Filter) -> Void)? = nil) {
    self.filters = filters
    self.selections = selections
    self.onClick = onClick
  }

}
#endif

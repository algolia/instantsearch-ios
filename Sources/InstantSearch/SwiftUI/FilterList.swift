//
//  FilterList.swift
//  
//
//  Created by Vladislav Fitc on 21/06/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// A view presenting the list of filters
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FilterList<Filter: FilterType & Hashable, Row: View, NoResults: View>: View {

  @ObservedObject public var filtersListObservableController: FilterListObservableController<Filter>

  /// Closure constructing a filter row view
  public var row: (Filter, Bool) -> Row

  /// Closure constructing a no results view
  public var noResults: (() -> NoResults)?

  public init(_ filtersListObservableController: FilterListObservableController<Filter>,
              @ViewBuilder row: @escaping (Filter, Bool) -> Row,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    self.filtersListObservableController = filtersListObservableController
    self.row = row
    self.noResults = noResults
  }

  public var body: some View {
    if let noResults = noResults?(), filtersListObservableController.filters.isEmpty {
      noResults
    } else {
      VStack {
        ForEach(filtersListObservableController.filters, id: \.self) { filter in
          row(filter, filtersListObservableController.isSelected(filter))
            .onTapGesture {
              filtersListObservableController.toggle(filter)
            }
        }
      }
    }
  }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension FilterList where NoResults == Never {

  init(_ filtersListObservableController: FilterListObservableController<Filter>,
       @ViewBuilder row: @escaping(Filter, Bool) -> Row) {
    self.filtersListObservableController = filtersListObservableController
    self.row = row
    self.noResults = nil
  }

}

#endif

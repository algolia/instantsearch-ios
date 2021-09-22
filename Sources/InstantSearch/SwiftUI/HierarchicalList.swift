//
//  HierarchicalList.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// A view presenting the list of hierarchical facets
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct HierarchicalList<Row: View, NoResults: View>: View {

  @ObservedObject public var hierarchicalObservableController: HierarchicalObservableController

  /// Closure constructing a hierarchical facet row view
  public var row: (Facet, Int, Bool) -> Row

  /// Closure constructing a no results view
  public var noResults: (() -> NoResults)?

  public init(_ hierarchicalObservableController: HierarchicalObservableController,
              @ViewBuilder row: @escaping (Facet, Int, Bool) -> Row,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    self.hierarchicalObservableController = hierarchicalObservableController
    self.row = row
    self.noResults = noResults
  }

  public var body: some View {
    if let noResults = noResults?(), hierarchicalObservableController.hierarchicalFacets.isEmpty {
      noResults
    } else {
      VStack {
        ForEach(hierarchicalObservableController.hierarchicalFacets, id: \.facet) { hierarchicalFacet in
          let (facet, level, isSelected) = hierarchicalFacet
          row(facet, level, isSelected)
            .onTapGesture {
              hierarchicalObservableController.toggle(facet.value)
            }
        }
      }
    }
  }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension HierarchicalList where NoResults == Never {

  init(_ hierarchicalObservableController: HierarchicalObservableController,
       @ViewBuilder row: @escaping(Facet, Int, Bool) -> Row) {
    self.hierarchicalObservableController = hierarchicalObservableController
    self.row = row
    self.noResults = nil
  }

}

@available(iOS 13.0, OSX 11.0, tvOS 13.0, watchOS 6.0, *)
struct HierarchicalListPreview: PreviewProvider {

  static var previews: some View {
    let demoController: HierarchicalObservableController = .init()
    HierarchicalList(demoController) { facet, nestingLevel, isSelected in
      HierarchicalFacetRow(facet: facet,
                           nestingLevel: nestingLevel,
                           isSelected: isSelected)
    }
    .onAppear {
      demoController.setItem([
        (Facet(value: "Category1", count: 10), 0, false),
        (Facet(value: "Category1 > Category1-1", count: 7), 1, false),
        (Facet(value: "Category1 > Category1-2", count: 2), 1, false),
        (Facet(value: "Category1 > Category1-3", count: 1), 1, false),
        (Facet(value: "Category2", count: 14), 0, true),
        (Facet(value: "Category2 > Category2-1", count: 8), 1, false),
        (Facet(value: "Category2 > Category2-2", count: 4), 1, true),
        (Facet(value: "Category2 > Category2-2 > Category2-2-1", count: 2), 2, false),
        (Facet(value: "Category2 > Category2-2 > Category2-2-2", count: 2), 2, true),
        (Facet(value: "Category2 > Category2-3", count: 2), 1, false)
      ])
    }
  }

}

#endif

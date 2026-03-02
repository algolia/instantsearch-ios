//
//  HierarchicalList.swift
//
//
//  Created by Vladislav Fitc on 10/04/2021.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64)) && !os(tvOS)
  import Combine
  import SwiftUI

  /// A view presenting the list of hierarchical facets
  @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
  public struct HierarchicalList<Row: View, NoResults: View>: View {
    @ObservedObject public var hierarchicalObservableController: HierarchicalObservableController

    /// Closure constructing a hierarchical facet row view
    public var row: (FacetHits, Int, Bool) -> Row

    /// Closure constructing a no results view
    public var noResults: (() -> NoResults)?

    public init(_ hierarchicalObservableController: HierarchicalObservableController,
                @ViewBuilder row: @escaping (FacetHits, Int, Bool) -> Row,
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
         @ViewBuilder row: @escaping (FacetHits, Int, Bool) -> Row) {
      self.hierarchicalObservableController = hierarchicalObservableController
      self.row = row
      noResults = nil
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
          (FacetHits(value: "Category1", highlighted: "", count: 10), 0, false),
          (FacetHits(value: "Category1 > Category1-1", highlighted: "", count: 7), 1, false),
          (FacetHits(value: "Category1 > Category1-2", highlighted: "", count: 2), 1, false),
          (FacetHits(value: "Category1 > Category1-3", highlighted: "", count: 1), 1, false),
          (FacetHits(value: "Category2", highlighted: "", count: 14), 0, true),
          (FacetHits(value: "Category2 > Category2-1", highlighted: "", count: 8), 1, false),
          (FacetHits(value: "Category2 > Category2-2", highlighted: "", count: 4), 1, true),
          (FacetHits(value: "Category2 > Category2-2 > Category2-2-1", highlighted: "", count: 2), 2, false),
          (FacetHits(value: "Category2 > Category2-2 > Category2-2-2", highlighted: "", count: 2), 2, true),
          (FacetHits(value: "Category2 > Category2-3", highlighted: "", count: 2), 1, false)
        ])
      }
    }
  }

#endif

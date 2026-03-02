//
//  FacetListObservableController.swift
//
//
//  Created by Vladislav Fitc on 29/03/2021.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
import InstantSearchTelemetry
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
  import Combine
  import SwiftUI

  /// FacetListController implementation adapted for usage with SwiftUI views
  @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
  public class FacetListObservableController: ObservableObject, FacetListController {
    /// List of facets to present
    @Published public var facets: [FacetHits]

    /// Set of selected facet values
    @Published public var selections: Set<String>

    public var onClick: ((FacetHits) -> Void)?

    /// Toggle facet selection
    public func toggle(_ facet: FacetHits) {
      onClick?(facet)
    }

    /// Returns a bool value indicating whether the provided facet is selected
    public func isSelected(_ facet: FacetHits) -> Bool {
      return selections.contains(facet.value)
    }

    public func setSelectableItems(selectableItems: [SelectableItem<FacetHits>]) {
      facets = selectableItems.map(\.item)
      selections = Set(selectableItems.filter(\.isSelected).map(\.item.value))
    }

    public func reload() {
      objectWillChange.send()
    }

    /**
     - parameters:
       - facets: List of facets to present
       - selections: Set of selected filters
       - onClick: Action triggered on interaction with filter
     */
    public init(facets: [FacetHits] = [],
                selections: Set<String> = [],
                onClick: ((FacetHits) -> Void)? = nil) {
      self.facets = facets
      self.selections = selections
      self.onClick = onClick
      InstantSearchTelemetry.shared.traceDeclarative(type: .facetList)
    }
  }
#endif

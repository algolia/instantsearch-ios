//
//  DynamicFacetListObservableController.swift
//  
//
//  Created by Vladislav Fitc on 15/06/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// DynamicFacetListController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class DynamicFacetListObservableController: ObservableObject, DynamicFacetListController {

  /// List of attributed facets to present
  @Published public var orderedFacets: [AttributedFacets]

  /// Mapping between a facet attribute and a set of selected facet values
  @Published public var selections: [Attribute: Set<String>]

  public func setOrderedFacets(_ orderedFacets: [AttributedFacets]) {
    self.orderedFacets = orderedFacets
  }

  public func setSelections(_ selections: [Attribute: Set<String>]) {
    self.selections = selections
  }

  public var didSelect: ((Attribute, Facet) -> Void)?

  /// Toggle facet selection
  public func toggle(_ facet: Facet, for attribute: Attribute) {
    didSelect?(attribute, facet)
  }

  /// Returns bool value indicating whether the provided facet for attribute is selected
  public func isSelected(_ facet: Facet, for attribute: Attribute) -> Bool {
    return selections[attribute]?.contains(facet.value) ?? false
  }

  public func reload() {
    objectWillChange.send()
  }

  /**
   - parameters:
     - orderedFacets: List of attributed facets to present
     - selections: Mapping between a facet attribute and a set of selected facet values
     - didSelect: A closure to trigger when user selects a facet
   */
  public init(orderedFacets: [AttributedFacets] = [],
              selections: [Attribute: Set<String>] = [:],
              didSelect: ((Attribute, Facet) -> Void)? = nil) {
    self.orderedFacets = orderedFacets
    self.selections = selections
    self.didSelect = didSelect
  }

}
#endif

//
//  DynamicFacetsInteractor.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public class DynamicFacetsInteractor {
  
  public typealias FacetSelections = [Attribute: Set<String>]
    
  public var shouldShowFacetForAttribute: (Attribute, Facet) -> (Bool) = { _, _ in true }
  
  private func prepareFacetOrder(_ facetOrder: FacetOrderContainer) -> [AttributedFacets] {
    return facetOrder.facetOrder
      .compactMap { attributedFacets in
        let filteredFacets = attributedFacets.facets.filter { shouldShowFacetForAttribute(attributedFacets.attribute, $0) }
        return AttributedFacets(attribute: attributedFacets.attribute, facets: filteredFacets)
      }.filter { !$0.facets.isEmpty }
  }
  
  public var facetOrder: FacetOrderContainer = .init() {
    didSet {
      onFacetOrderUpdated.fire(FacetOrderContainer(facetOrder: prepareFacetOrder(facetOrder)))
    }
  }
  
  public var selections: FacetSelections = .init() {
    didSet {
      onSelectionsUpdated.fire(selections)
    }
  }
  
  public let onFacetOrderUpdated: Observer<FacetOrderContainer>
  public let onSelectionsUpdated: Observer<FacetSelections>
  
  public init(facetOrder: FacetOrderContainer, selections: [Attribute: Set<String>]) {
    self.facetOrder = facetOrder
    self.selections = selections
    self.onFacetOrderUpdated = .init()
    self.onSelectionsUpdated = .init()
    onFacetOrderUpdated.fire(facetOrder)
    onSelectionsUpdated.fire(selections)
  }
  
  public func isSelected(facetValue: String, for attribute: Attribute) -> Bool {
    return selections[attribute]?.contains(facetValue) ?? false
  }
  
  public func toggleSelection(ofFacetValue facetValue: String, for attribute: Attribute) {
    var currentSelections = selections[attribute] ?? []
    if currentSelections.contains(facetValue) {
      currentSelections.remove(facetValue)
    } else {
      currentSelections.insert(facetValue)
    }
    selections[attribute] = currentSelections.isEmpty ? nil : currentSelections
  }
  
}

//
//  DynamicFacetsInteractor.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public class DynamicFacetsInteractor {
  
  public typealias FacetSelections = [Attribute: Set<String>]
  
  public var facetOrder: [AttributedFacets] = .init() {
    didSet {
      onFacetOrderUpdated.fire(facetOrder)
    }
  }
  
  public var selections: FacetSelections = .init() {
    didSet {
      onSelectionsUpdated.fire(selections)
    }
  }
    
  public let onFacetOrderUpdated: Observer<[AttributedFacets]>
  public let onSelectionsUpdated: Observer<FacetSelections>
  public let selectionModeForAttribute: [Attribute: SelectionMode]

  public init(facetOrder: [AttributedFacets] = [],
              selections: [Attribute: Set<String>] = [:],
              selectionModeForAttribute: [Attribute: SelectionMode] = [:]) {
    self.facetOrder = facetOrder
    self.selections = selections
    self.onFacetOrderUpdated = .init()
    self.onSelectionsUpdated = .init()
    self.selectionModeForAttribute = selectionModeForAttribute
    onFacetOrderUpdated.fire(facetOrder)
    onSelectionsUpdated.fire(selections)
  }
  
  public func isSelected(facetValue: String, for attribute: Attribute) -> Bool {
    return selections[attribute]?.contains(facetValue) ?? false
  }
  
  public func toggleSelection(ofFacetValue facetValue: String, for attribute: Attribute) {
    computeSelections(selectingItemForKey: facetValue, for: attribute)
  }
  
  public func computeSelections(selectingItemForKey key: String, for attribute: Attribute) {

    let currentSelections = selections[attribute] ?? []
    let selectionMode = selectionModeForAttribute[attribute] ?? .single
    
    let computedSelections: Set<String>

    switch (selectionMode, currentSelections.contains(key)) {
    case (.single, true):
      computedSelections = []

    case (.single, false):
      computedSelections = [key]

    case (.multiple, true):
      computedSelections = currentSelections.subtracting([key])

    case (.multiple, false):
      computedSelections = currentSelections.union([key])
    }
    
    selections[attribute] = computedSelections
  }

}

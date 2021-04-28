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
  
  public init(facetOrder: [AttributedFacets], selections: [Attribute: Set<String>]) {
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

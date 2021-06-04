//
//  BuildFacetOrder.swift
//  
//
//  Created by Vladislav Fitc on 14/04/2021.
//

import Foundation

struct BuildFacetOrder {
  
  let facetOrder: FacetOrdering
  let facets: [Attribute: [Facet]]
  
  init(facetOrder: FacetOrdering, facets: [Attribute: [Facet]]) {
    self.facetOrder = facetOrder
    self.facets = facets
  }
    
  func order(facets: [Facet], with rule: FacetValuesOrder) -> [Facet] {
    
    let pinnedFacets: [Facet]
    
    if let order = rule.order {
      pinnedFacets = order.compactMap { value in facets.first { $0.value == value } }
    } else {
      pinnedFacets = []
    }
    
    guard let sortRemainingBy = rule.sortRemainingBy else {
      return pinnedFacets
    }
    
    let remainingFacets = facets.filter { !pinnedFacets.contains($0) }

    let facetsTail: [Facet]
    switch sortRemainingBy {
    case .hidden:
      facetsTail = []
      
    case .alpha:
      facetsTail = remainingFacets.sorted { $0.value < $1.value }
      
    case .count:
      facetsTail = remainingFacets.sorted { $0.count > $1.count }
    }
    
    return pinnedFacets + facetsTail
  }

  
  func callAsFunction() -> [AttributedFacets] {
    
    let orderedAttributes = facetOrder.facets.order.compactMap { attribute in facets.keys.first { $0 == attribute } }
    
    return orderedAttributes.map { attribute in
      let facetValues = facets[attribute] ?? []
      let orderedFacetValues: [Facet]
      if let orderingRule = facetOrder.values[attribute] {
        orderedFacetValues = order(facets: facetValues, with: orderingRule)
      } else {
        orderedFacetValues = facetValues
      }
      return AttributedFacets(attribute: attribute, facets: orderedFacetValues)
    }
    
  }
  
}

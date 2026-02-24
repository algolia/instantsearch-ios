//
//  FacetsOrderer.swift
//
//
//  Created by Vladislav Fitc on 14/04/2021.
//

import Foundation

/**
 Encapsulates the algortihm transforming the received facets and facet ordering rules to the list of ordered facet attributes and ordered values
 */
struct FacetsOrderer {
  /// Facets per attribute
  let facets: [String: [FacetHits]]

  /// Facets ordering rule
  let facetOrdering: SearchFacetOrdering

  /**
    - parameters:
      - facetOrder: Facets per attribute
      - facet: Facets ordering rule
   */
  init(facetOrder: SearchFacetOrdering, facets: [String: [FacetHits]]) {
    facetOrdering = facetOrder
    self.facets = facets
  }

  /// Apply the ordering rule to the facets and their values
  /// - returns: The list of ordered facet attributes and ordered values
  func callAsFunction() -> [AttributedFacets] {
    let orderedAttributes = (facetOrdering.facets?.order ?? [])
      .compactMap { attribute in facets.keys.first { $0 == attribute } }

    return orderedAttributes.map { attribute in
      let facetValues = facets[attribute] ?? []
      let orderedFacetValues: [FacetHits]
      if let orderingRule = facetOrdering.values?[attribute] {
        orderedFacetValues = order(facets: facetValues, with: orderingRule)
      } else {
        orderedFacetValues = facetValues
      }
      return AttributedFacets(attribute: attribute, facets: orderedFacetValues)
    }
  }

  /// Order facet values
  /// - parameter facets: the list of facets to order
  /// - parameter rule: the ordering rule for facets
  /// - returns: the list of ordered facets
  private func order(facets: [FacetHits], with rule: SearchValue) -> [FacetHits] {
    guard facets.count > 1 else {
      return facets
    }

    let hiddenValues = Set(rule.hide ?? [])
    let availableFacets = facets.filter { !hiddenValues.contains($0.value) }

    let pinnedFacets: [FacetHits] = (rule.order ?? []).compactMap { value in
      availableFacets.first { $0.value == value }
    }

    let remainingFacets = availableFacets.filter { !pinnedFacets.contains($0) }

    let facetsTail: [FacetHits]
    switch rule.sortRemainingBy ?? .count {
    case .hidden:
      facetsTail = []
    case .alpha:
      facetsTail = remainingFacets.sorted { $0.value < $1.value }
    case .count:
      facetsTail = remainingFacets.sorted { $0.count > $1.count }
    }

    return pinnedFacets + facetsTail
  }
}

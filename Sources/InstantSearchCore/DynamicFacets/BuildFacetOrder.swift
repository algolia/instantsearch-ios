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
  
  func filterPredicate<E>(valuePath: KeyPath<E, String>,
                          order: [String],
                          hide: [String]) -> (E) -> Bool {
    { object in
      let value = object[keyPath: valuePath]
      return !hide.contains(value) && (order.contains("*") || order.contains(value)) }
  }
  
  func predicate<E>(valuePath: KeyPath<E, String>,
                    countPath: KeyPath<E, Int>,
                    order: [String],
                    sortBy: OrderingRule.SortRule?) -> (E, E) -> Bool {
    { l, r in
      switch (order.firstIndex(of: l[keyPath: valuePath]), order.firstIndex(of: r[keyPath: valuePath])) {
      case (.some(let li), .some(let ri)):
        return li < ri
      case (.some, .none):
        return true
      case (.none, .some):
        return false
      case (.none, .none):
        let sortBy = sortBy ?? .alpha
        switch sortBy {
        case .alpha:
          return l[keyPath: valuePath] < r[keyPath: valuePath]
        case .count:
          return l[keyPath: countPath] < r[keyPath: countPath]
        }
      }
    }
  }
  
  func order<E>(input: [E],
                with rule: OrderingRule,
                valuePath: KeyPath<E, String>,
                countPath: KeyPath<E, Int>) -> [E] {
    let order = rule.order ?? ["*"]
    let hide = rule.hide ?? []
    return input
      .filter(filterPredicate(valuePath: valuePath, order: order, hide: hide))
      .sorted(by: predicate(valuePath: valuePath, countPath: countPath, order: order, sortBy: rule.sortBy))
  }

  
  func callAsFunction() -> [AttributedFacets] {
    
    order(input: Array(facets),
          with: facetOrder.facets,
          valuePath: \.0.rawValue,
          countPath: \.1.count)
    .map { (attribute, facets) -> AttributedFacets in
      let rule = facetOrder.facetValues[attribute.rawValue] ?? .init()
      let orderedFacetValues = order(input: facets,
                                     with: rule,
                                     valuePath: \.value,
                                     countPath: \.count)
      return AttributedFacets(attribute: attribute, facets: orderedFacetValues)
    }
  }
  
}

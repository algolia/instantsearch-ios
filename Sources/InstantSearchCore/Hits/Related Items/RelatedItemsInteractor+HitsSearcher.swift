//
//  RelatedItemsInteractor+HitsSearcher.swift
//  InstantSearchCore
//
//  Created by test test on 23/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import Search

extension HitsInteractor {
  @discardableResult public func connectSearcher<T>(_ searcher: HitsSearcher, withRelatedItemsTo hit: ObjectWrapper<T>, with matchingPatterns: [MatchingPattern<T>]) -> HitsSearcherConnection {
    let connection = HitsSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()

    let optionalFilters = generateOptionalFilters(from: matchingPatterns, and: hit)
    let excludeFilter = Filter.Facet(attribute: "objectID", stringValue: hit.objectID, isNegated: true)

    searcher.request.query.sumOrFiltersScores = true
    searcher.request.query.filters = FilterGroupConverter().sql([FilterGroup.And(filters: [excludeFilter])])
    if let optionalFilters {
      searcher.request.query.optionalFilters = .arrayOfSearchOptionalFilters(optionalFilters.map { .string($0) })
    }

    return connection
  }

  func generateOptionalFilters<T>(from matchingPatterns: [MatchingPattern<T>], and hit: ObjectWrapper<T>) -> [String]? {
    let filterState = FilterState()

    for matchingPattern in matchingPatterns {
      switch matchingPattern.oneOrManyElementsInKeyPath {
      case let .one(keyPath): // // in the case of a single facet associated to a filter -> AND Behaviours
        let facetValue = hit.object[keyPath: keyPath]
        let facetFilter = Filter.Facet(attribute: matchingPattern.attribute, value: .string(facetValue), score: matchingPattern.score)
        filterState[and: matchingPattern.attribute].add(facetFilter)
      case let .many(keyPath): // in the case of multiple facets associated to a filter -> OR Behaviours
        let facetFilters = hit.object[keyPath: keyPath].map { Filter.Facet(attribute: matchingPattern.attribute, value: .string($0), score: matchingPattern.score) }
        filterState[or: matchingPattern.attribute].addAll(facetFilters)
      }
    }

    guard let legacyFilters = FilterGroupConverter().legacy(filterState.toFilterGroups()) else {
      return nil
    }
    return legacyFilters.units.flatMap(\.rawFilters)
  }
}

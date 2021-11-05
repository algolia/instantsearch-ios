//
//  RelatedItemsInteractor+HitsSearcher.swift
//  InstantSearchCore
//
//  Created by test test on 23/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

extension HitsInteractor {

  @discardableResult public func connectSearcher<T>(_ searcher: HitsSearcher, withRelatedItemsTo hit: ObjectWrapper<T>, with matchingPatterns: [MatchingPattern<T>]) -> HitsSearcherConnection {
    let connection = HitsSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()

    let legacyFilters = generateOptionalFilters(from: matchingPatterns, and: hit)

    searcher.request.query.sumOrFiltersScores = true

    searcher.request.query.facetFilters = [.and("objectID:-\(hit.objectID)")]
    searcher.request.query.optionalFilters = legacyFilters

    return connection
  }

  func generateOptionalFilters<T>(from matchingPatterns: [MatchingPattern<T>], and hit: ObjectWrapper<T>) -> FiltersStorage? {
    let filterState = FilterState()

    for matchingPattern in matchingPatterns {
      switch matchingPattern.oneOrManyElementsInKeyPath {
      case .one(let keyPath): // // in the case of a single facet associated to a filter -> AND Behaviours
        let facetValue = hit.object[keyPath: keyPath]
        let facetFilter = Filter.Facet.init(attribute: matchingPattern.attribute, value: .string(facetValue), score: matchingPattern.score)
        filterState[and: matchingPattern.attribute.rawValue].add(facetFilter)
      case .many(let keyPath): // in the case of multiple facets associated to a filter -> OR Behaviours
        let facetFilters = hit.object[keyPath: keyPath].map { Filter.Facet.init(attribute: matchingPattern.attribute, value: .string($0), score: matchingPattern.score) }
        filterState[or: matchingPattern.attribute.rawValue].addAll(facetFilters)
      }
    }

    return FilterGroupConverter().legacy(filterState.toFilterGroups())
  }

}

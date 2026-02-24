//
//  Boundable+HitsSearcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, renamed: "HitsSearcherConnection")
public typealias BoundableSingleIndexSearcherConnection = BoundableHitsSearcherConnection

public struct BoundableHitsSearcherConnection<B: Boundable>: Connection {
  public let boundable: B
  public let searcher: HitsSearcher
  public let attribute: String

  public func connect() {
    let attribute = self.attribute
    searcher.request.query.updateQueryFacets(with: attribute)
    searcher.onResults.subscribePastOnce(with: boundable) { boundable, searchResults in
      boundable.computeBoundsFromFacetStats(attribute: attribute, facetStats: searchResults.facetsStats)
    }
  }

  public func disconnect() {
    searcher.onResults.cancelSubscription(for: searcher)
  }
}

extension Boundable {
  @discardableResult public func connectSearcher(_ searcher: HitsSearcher, attribute: String) -> BoundableHitsSearcherConnection<Self> {
    let connection = BoundableHitsSearcherConnection(boundable: self, searcher: searcher, attribute: attribute)
    connection.connect()
    return connection
  }

  func computeBoundsFromFacetStats(attribute: String, facetStats: [String: FacetStats]?) {
    guard let facetStats = facetStats, let facetStatsOfAttribute = facetStats[attribute] else {
      applyBounds(bounds: nil)
      return
    }

    guard let min = facetStatsOfAttribute.min, let max = facetStatsOfAttribute.max else {
      applyBounds(bounds: nil)
      return
    }
    applyBounds(bounds: Number(min)...Number(max))
  }
}

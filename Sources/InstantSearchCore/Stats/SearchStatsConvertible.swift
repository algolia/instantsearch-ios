//
//  SearchStatsConvertible.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 15/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public protocol SearchStatsConvertible {

  var searchStats: SearchStats { get }

}

extension SearchResponse: SearchStatsConvertible {

  public var searchStats: SearchStats {
    return .init(totalHitsCount: nbHits ?? 0,
                 nbSortedHits: nbSortedHits,
                 hitsPerPage: hitsPerPage ?? 20,
                 pagesCount: nbPages ?? 1,
                 page: page ?? 0,
                 processingTimeMS: processingTimeMS.flatMap(Int.init) ?? 0,
                 query: query,
                 queryID: queryID)
  }

}

extension PlacesResponse: SearchStatsConvertible {

  public var searchStats: SearchStats {
    return .init(totalHitsCount: nbHits,
                 hitsPerPage: nbHits,
                 pagesCount: 1,
                 page: 0,
                 processingTimeMS: Int(processingTimeMS),
                 query: query,
                 queryID: nil)
  }

}

extension FacetSearchResponse: SearchStatsConvertible {

  public var searchStats: SearchStats {
    return .init(totalHitsCount: facetHits.count,
                 hitsPerPage: facetHits.count,
                 pagesCount: 1,
                 page: 0,
                 processingTimeMS: Int(processingTimeMS),
                 query: nil,
                 queryID: nil)
  }

}

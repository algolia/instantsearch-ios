//
//  HitsResponse.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 15/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public protocol HitsExtractable {

  func extractHits<T: Decodable>() throws -> [T]

}

extension SearchResponse: HitsExtractable {}

extension PlacesResponse: HitsExtractable {

  public func extractHits<T>() throws -> [T] where T: Decodable {
    let hitsData = try JSONEncoder().encode(hits)
    return try JSONDecoder().decode([T].self, from: hitsData)
  }

}

extension FacetSearchResponse: HitsExtractable {

  public func extractHits<T>() throws -> [T] where T: Decodable {
    let hitsData = try JSONEncoder().encode(facetHits)
    return try JSONDecoder().decode([T].self, from: hitsData)
  }

}

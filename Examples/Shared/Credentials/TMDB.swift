//
//  TMDB.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Foundation
import AlgoliaSearchClient

extension SearchClient {
  static let tmdb = Self(appID: "latency", apiKey: "3832e8fcaf80b1c7085c59fa3e4d266d")
}

extension IndexName {
  static let tmdbMovies: IndexName = "tmdb_movies_shows"
}

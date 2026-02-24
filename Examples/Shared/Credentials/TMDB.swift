//
//  TMDB.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Search
import Foundation

extension SearchClient {
  static let tmdb = try! SearchClient(appID: "latency", apiKey: "3832e8fcaf80b1c7085c59fa3e4d266d")
}

extension String {
  static let tmdbMovies = "tmdb_movies_shows"
}

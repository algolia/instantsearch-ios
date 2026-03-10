//
//  InstantSearch.swift
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import AlgoliaSearch
import Foundation

extension SearchClient {
  static let instantSearch = try! SearchClient(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
}

extension String {
  static let instantSearch = "instant_search"
  static let instantSearchSuggestions = "instant_search_demo_query_suggestions"
  static let movies = "mobile_demo_movies"
  static let actors = "mobile_demo_actors"

  static let facetList = "mobile_demo_facet_list"
  static let facetSearch = "mobile_demo_facet_list_search"
  static let hierarchicalFacets = "mobile_demo_hierarchical"
  static let filterList = "mobile_demo_filter_list"
  static let filterNumericComparison = "mobile_demo_filter_numeric_comparison"
  static let filterSegment = "mobile_demo_filter_segment"
  static let filterToggle = "mobile_demo_filter_toggle"
}

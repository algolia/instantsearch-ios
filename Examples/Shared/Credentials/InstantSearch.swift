//
//  InstantSearch.swift
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Foundation
import AlgoliaSearchClient

extension SearchClient {
  static let instantSearch = Self(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
}

extension IndexName {
  static let instantSearch: IndexName = "instant_search"
  static let instantSearchSuggestions: IndexName = "instant_search_demo_query_suggestions"
  static let movies: IndexName = "mobile_demo_movies"
  static let actors: IndexName = "mobile_demo_actors"

  static let facetList: IndexName = "mobile_demo_facet_list"
  static let facetSearch: IndexName = "mobile_demo_facet_list_search"
  static let hierarchicalFacets: IndexName = "mobile_demo_hierarchical"
  static let filterList: IndexName = "mobile_demo_filter_list"
  static let filterNumericComparison: IndexName = "mobile_demo_filter_numeric_comparison"
  static let filterSegment: IndexName = "mobile_demo_filter_segment"
  static let filterToggle: IndexName = "mobile_demo_filter_toggle"

}

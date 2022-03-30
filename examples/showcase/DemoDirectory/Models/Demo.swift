//
//  Demo.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 09/06/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

struct Demo: Codable {
  
  let objectID: String
  let name: String
  let type: String
  let index: String
  
  enum ID: String {
    case singleIndex = "paging_single_index"
    case multiIndex = "paging_multiple_index"
    case sffv = "facet_list_search"
    case toggle = "filter_toggle"
    case toggleDefault = "filter_toggle_default"
    case facetList = "facet_list"
    case dynamicFacetList = "dynamic_facets"
    case facetListPersistentSelection = "facet_list_persistent"
    case segmented = "filter_segment"
//    case allFilterList = "filter_list_all"
    case mergedList = "merged_list"
    case facetFilterList = "filter_list_facet"
    case numericFilterList = "filter_list_numeric"
    case tagFilterList = "filter_list_tag"
    case filterNumericComparison = "filter_numeric_comparison"
    case sortBy = "sort_by"
    case currentFilters = "filter_current"
    case searchAsYouType = "search_as_you_type"
    case searchOnSubmit = "search_on_submit"
    case clearFilters = "filter_clear"
    case filterNumericRange = "filter_numeric_range"
    case filterRating = "filter_rating"
    case stats
    case highlighting
    case loading
    case hierarchical = "filter_hierarchical"
    case querySuggestions = "query_suggestions"
    case relatedItems = "personalisation_related_items"
    case queryRuleCustomData = "query_rule_custom_data"
    case relevantSort = "dynamic_sort"
    case voiceSearch = "voice_search"
  }
  
}

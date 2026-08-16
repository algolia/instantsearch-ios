//
//  Composition+SearchResponse.swift
//  InstantSearchCore
//

import AlgoliaComposition
import AlgoliaCore
import AlgoliaSearch
import Foundation

extension SearchResultsItem {
  /// Regular search response built from a composition run result, allowing the reuse of
  /// all the components consuming `SearchResponse` values.
  var searchResponse: AlgoliaSearch.SearchResponse<T> {
    AlgoliaSearch.SearchResponse<T>(
      abTestID: abTestID,
      abTestVariantID: abTestVariantID,
      aroundLatLng: aroundLatLng,
      automaticRadius: automaticRadius,
      exhaustive: convert(exhaustive),
      appliedRules: appliedRules,
      facets: facets,
      facetsStats: convert(facetsStats),
      index: index,
      indexUsed: indexUsed,
      message: message,
      nbSortedHits: nbSortedHits,
      parsedQuery: parsedQuery,
      processingTimeMS: processingTimeMS,
      processingTimingsMS: processingTimingsMS,
      queryAfterRemoval: queryAfterRemoval,
      redirect: convert(redirect),
      renderingContent: convert(renderingContent),
      serverTimeMS: serverTimeMS,
      serverUsed: serverUsed,
      userData: userData,
      queryID: queryID,
      automaticInsights: automaticInsights,
      page: page,
      nbHits: nbHits,
      nbPages: nbPages,
      hitsPerPage: hitsPerPage,
      hits: hits ?? [],
      query: query,
      params: params
    )
  }
}

extension AlgoliaComposition.SearchForFacetValuesResults {
  /// Regular search for facet values response built from a composition facet values search result
  var searchForFacetValuesResponse: AlgoliaSearch.SearchForFacetValuesResponse {
    AlgoliaSearch.SearchForFacetValuesResponse(
      facetHits: facetHits.map { AlgoliaSearch.FacetHits(value: $0.value, highlighted: $0.highlighted, count: $0.count) },
      exhaustiveFacetsCount: exhaustiveFacetsCount,
      processingTimeMS: processingTimeMS
    )
  }
}

/// Converts a value between two structurally identical `Codable` types generated
/// for different API client modules by the means of a JSON coding roundtrip.
private func convert<Source: Encodable, Destination: Decodable>(_ value: Source?) -> Destination? {
  guard let value, let data = try? JSONEncoder().encode(value) else {
    return nil
  }
  return try? JSONDecoder().decode(Destination.self, from: data)
}

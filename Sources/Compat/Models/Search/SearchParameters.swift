//
//  SearchParameters.swift
//
//
//  Created by Vladislav Fitc on 19/11/2020.
//

import Foundation

public protocol SearchParameters: CommonParameters {

  // MARK: - Search

  /**
   The text to search in the index.
   - Engine default: ""
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/query/?language=swift)
  */
  var query: String? { get set }

  /**
    Overrides the query parameter and performs a more generic search that can be used to find "similar" results.
    Engine default: ""
    [Documentation][htt ps://www.algolia.com/doc/api-reference/api-parameters/similarQuery/?language=swift)
   */
  var similarQuery: String? { get set }

  // MARK: - Attributes

  /**
   Restricts a given query to look in only a subset of your searchable attributes.
   - Engine default: all attributes in [Settings.searchableAttributes].
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/restrictSearchableAttributes/?language=swift)
   */
  var restrictSearchableAttributes: [Attribute]? { get set }

  // MARK: - Filtering

  /**
   Filter the query with numeric, facet and/or tag filters.
   - Engine default: ""
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/filters/?language=swift)
   */
  var filters: String? { get set }

  /**
   Filter hits by facet value.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facetFilters/?language=swift)
   */
  var facetFilters: FiltersStorage? { get set }

  /**
   Create filters for ranking purposes, where records that match the filter are ranked highest.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/optionalFilters/?language=swift)
   */
  var optionalFilters: FiltersStorage? { get set }

  /**
   Filter on numeric attributes.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/numericFilters/?language=swift)
   */
  var numericFilters: FiltersStorage? { get set }

  /**
   Filter hits by tags.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/tagFilters/?language=swift)
   */
  var tagFilters: FiltersStorage? { get set }

  /**
   Determines how to calculate the total score for filtering.
   - Engine default: false
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/sumOrFiltersScores/?language=swift)
   */
  var sumOrFiltersScores: Bool? { get set }

  // MARK: - Faceting

  /**
   Facets to retrieve.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facets/?language=swift)
   */
  var facets: Set<Attribute>? { get set }

  /**
   Force faceting to be applied after de-duplication (via the Distinct setting).
   - Engine default: false
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facetingAfterDistinct/?language=swift)
   */
  var facetingAfterDistinct: Bool? { get set }

  // MARK: - Pagination

  /**
   Specify the page to retrieve.
   - Engine default: 0
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/page/?language=swift)
   */
  var page: Int? { get set }

  /**
   Set the number of hits per page.
   - Engine default: 20
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/hitsPerPage/?language=swift)
   */
  var hitsPerPage: Int? { get set }

  /**
   Specify the offset of the first hit to return.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/offset/?language=swift)
   */
  var offset: Int? { get set }

  /**
   Set the number of hits to retrieve (used only with offset).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/length/?language=swift)
   */
  var length: Int? { get set }

  // MARK: - Geo-Search

  /**
   Search for entries around a central geolocation, enabling a geo search within a circular area.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLng/?language=swift)
   */
  var aroundLatLng: Point? { get set }

  /**
   Whether to search entries around a given location automatically computed from the requester’s IP address.
   - Engine default: false
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLngViaIP/?language=swift)
   */
  var aroundLatLngViaIP: Bool? { get set }

  /**
   Define the maximum radius for a geo search (in meters).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundRadius/?language=swift)
   */
  var aroundRadius: AroundRadius? { get set }

  /**
   Precision of geo search (in meters), to add grouping by geo location to the ranking formula.
   - Engine default: 1
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundPrecision/?language=swift)
   */
  var aroundPrecision: [AroundPrecision]? { get set }

  /**
   Minimum radius (in meters) used for a geo search when [aroundRadius] is not set.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/minimumAroundRadius/?language=swift)
   */
  var minimumAroundRadius: Int? { get set }

  /**
   Search inside a rectangular area (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
   */
  var insideBoundingBox: [BoundingBox]? { get set }

  /**
   Search inside a polygon (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insidePolygon/?language=swift)
   */
  var insidePolygon: [Polygon]? { get set }

  // MARK: - Languages

  /**
   List of supported languages with their associated language ISO code.
   Provide an easy way to implement voice and natural languages best practices such as ignorePlurals,
   removeStopWords, removeWordsIfNoResults, analyticsTags and ruleContexts.
  */
  var naturalLanguages: [Language]? { get set }

  // MARK: - Query rules

  /**
   Enables contextual rules.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/ruleContexts/?language=swift)
   */
  var ruleContexts: [String]? { get set }

  // MARK: - Personalization

  /**
    The `personalizationImpact` parameter sets the percentage of the impact that personalization has on ranking
    records.
    This is set at query time and therefore overrides any impact value you had set on your index.
    The higher the `personalizationImpact`, the more the results are personalized for the user, and the less the
    custom ranking is taken into account in ranking records.
   *
    Usage note:
   *
    - The value must be between 0 and 100 (inclusive).
    - This parameter isn't taken into account if `enablePersonalization` is `false`.
    - Setting `personalizationImpact` to `0` disables the Personalization feature, as if `enablePersonalization`
      were `false`.
   */
  var personalizationImpact: Int? { get set }

  /**
   Associates a certain user token with the current search.
   - Engine default: User ip address
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/userToken/?language=swift)
   */
  var userToken: UserToken? { get set }

  // MARK: - Advanced

  /**
   Retrieve detailed ranking information.
   - Engine default: false
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/getRankingInfo/?language=swift)
   */
  var getRankingInfo: Bool? { get set }

  /**
   Enable the Click Analytics feature.
   - Engine default: false.
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/clickAnalytics/?language=swift)
   */
  var clickAnalytics: Bool? { get set }

  /**
   Whether the current query will be taken into account in the Analytics.
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/analytics/?language=swift)
   */
  var analytics: Bool? { get set }

  /**
   List of tags to apply to the query in the analytics.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/analyticsTags/?language=swift)
   */
  var analyticsTags: [String]? { get set }

  /**
   Whether to take into account an index’s synonyms for a particular search.
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/synonyms/?language=swift)
   */
  var synonyms: Bool? { get set }

  /**
   Whether to include or exclude a query from the processing-time percentile computation.
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/percentileComputation/?language=swift)
   */
  var percentileComputation: Bool? { get set }

  /**
   Whether this query should be taken into consideration by currently active ABTests.
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/enableABTest/?language=swift)
   */
  var enableABTest: Bool? { get set }

  /**
   Enriches the API’s response with meta-information as to how the query was processed.
   It is possible to enable several ExplainModule independently.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/_/?language=swift)
   */
  var explainModules: [ExplainModule]? { get set }

  /**
   Whether this search should use [Dynamic Re-Ranking](https://www.algolia.com/doc/guides/algolia-ai/re-ranking/).
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/enableReRanking/?language=swift)
   */

  var enableReRanking: Bool? { get set }

}

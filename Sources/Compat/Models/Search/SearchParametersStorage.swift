//
//  SearchParametersStorage.swift
//
//
//  Created by Vladislav Fitc on 19/11/2020.
//

import Foundation

public struct SearchParametersStorage: SearchParameters, Equatable {
  public var query: String?
  public var similarQuery: String?
  public var attributesToRetrieve: [Attribute]?
  public var restrictSearchableAttributes: [Attribute]?
  public var filters: String?
  public var facetFilters: FiltersStorage?
  public var optionalFilters: FiltersStorage?
  public var numericFilters: FiltersStorage?
  public var tagFilters: FiltersStorage?
  public var sumOrFiltersScores: Bool?
  public var facets: Set<Attribute>?
  public var maxValuesPerFacet: Int?
  public var facetingAfterDistinct: Bool?
  public var sortFacetsBy: SortFacetsBy?
  public var attributesToHighlight: [Attribute]?
  public var attributesToSnippet: [Snippet]?
  public var highlightPreTag: String?
  public var highlightPostTag: String?
  public var snippetEllipsisText: String?
  public var restrictHighlightAndSnippetArrays: Bool?
  public var page: Int?
  public var hitsPerPage: Int?
  public var offset: Int?
  public var length: Int?
  public var minWordSizeFor1Typo: Int?
  public var minWordSizeFor2Typos: Int?
  public var typoTolerance: TypoTolerance?
  public var allowTyposOnNumericTokens: Bool?
  public var disableTypoToleranceOnAttributes: [Attribute]?
  public var aroundLatLng: Point?
  public var aroundLatLngViaIP: Bool?
  public var aroundRadius: AroundRadius?
  public var aroundPrecision: [AroundPrecision]?
  public var minimumAroundRadius: Int?
  public var insideBoundingBox: [BoundingBox]?
  public var insidePolygon: [Polygon]?
  public var ignorePlurals: LanguageFeature?
  public var removeStopWords: LanguageFeature?
  public var queryLanguages: [Language]?
  public var naturalLanguages: [Language]?
  public var decompoundQuery: Bool?
  public var enableRules: Bool?
  public var ruleContexts: [String]?
  public var enablePersonalization: Bool?
  public var personalizationImpact: Int?
  public var userToken: UserToken?
  public var queryType: QueryType?
  public var removeWordsIfNoResults: RemoveWordIfNoResults?
  public var advancedSyntax: Bool?
  public var optionalWords: [String]?
  public var disableExactOnAttributes: [Attribute]?
  public var exactOnSingleWordQuery: ExactOnSingleWordQuery?
  public var alternativesAsExact: [AlternativesAsExact]?
  public var advancedSyntaxFeatures: [AdvancedSyntaxFeatures]?
  public var distinct: Distinct?
  public var getRankingInfo: Bool?
  public var clickAnalytics: Bool?
  public var analytics: Bool?
  public var analyticsTags: [String]?
  public var synonyms: Bool?
  public var replaceSynonymsInHighlight: Bool?
  public var minProximity: Int?
  public var responseFields: [ResponseField]?
  public var maxFacetHits: Int?
  public var percentileComputation: Bool?
  public var attributeCriteriaComputedByMinProximity: Bool?
  public var enableABTest: Bool?
  public var explainModules: [ExplainModule]?
  public var relevancyStrictness: Int?
  public var enableReRanking: Bool?
}

protocol SearchParametersStorageContainer: SearchParameters {

  var searchParametersStorage: SearchParametersStorage { get set }

}

extension SearchParametersStorageContainer {
  public var query: String? {
    get { searchParametersStorage.query }
    set { searchParametersStorage.query = newValue }
  }
  public var similarQuery: String? {
    get { searchParametersStorage.similarQuery }
    set { searchParametersStorage.similarQuery = newValue }
  }
  public var attributesToRetrieve: [Attribute]? {
    get { searchParametersStorage.attributesToRetrieve }
    set { searchParametersStorage.attributesToRetrieve = newValue }
  }
  public var restrictSearchableAttributes: [Attribute]? {
    get { searchParametersStorage.restrictSearchableAttributes }
    set { searchParametersStorage.restrictSearchableAttributes = newValue }
  }
  public var filters: String? {
    get { searchParametersStorage.filters }
    set { searchParametersStorage.filters = newValue }
  }
  public var facetFilters: FiltersStorage? {
    get { searchParametersStorage.facetFilters }
    set { searchParametersStorage.facetFilters = newValue }
  }
  public var optionalFilters: FiltersStorage? {
    get { searchParametersStorage.optionalFilters }
    set { searchParametersStorage.optionalFilters = newValue }
  }
  public var numericFilters: FiltersStorage? {
    get { searchParametersStorage.numericFilters }
    set { searchParametersStorage.numericFilters = newValue }
  }
  public var tagFilters: FiltersStorage? {
    get { searchParametersStorage.tagFilters }
    set { searchParametersStorage.tagFilters = newValue }
  }
  public var sumOrFiltersScores: Bool? {
    get { searchParametersStorage.sumOrFiltersScores }
    set { searchParametersStorage.sumOrFiltersScores = newValue }
  }
  public var facets: Set<Attribute>? {
    get { searchParametersStorage.facets }
    set { searchParametersStorage.facets = newValue }
  }
  public var maxValuesPerFacet: Int? {
    get { searchParametersStorage.maxValuesPerFacet }
    set { searchParametersStorage.maxValuesPerFacet = newValue }
  }
  public var facetingAfterDistinct: Bool? {
    get { searchParametersStorage.facetingAfterDistinct }
    set { searchParametersStorage.facetingAfterDistinct = newValue }
  }
  public var sortFacetsBy: SortFacetsBy? {
    get { searchParametersStorage.sortFacetsBy }
    set { searchParametersStorage.sortFacetsBy = newValue }
  }
  public var attributesToHighlight: [Attribute]? {
    get { searchParametersStorage.attributesToHighlight }
    set { searchParametersStorage.attributesToHighlight = newValue }
  }
  public var attributesToSnippet: [Snippet]? {
    get { searchParametersStorage.attributesToSnippet }
    set { searchParametersStorage.attributesToSnippet = newValue }
  }
  public var highlightPreTag: String? {
    get { searchParametersStorage.highlightPreTag }
    set { searchParametersStorage.highlightPreTag = newValue }
  }
  public var highlightPostTag: String? {
    get { searchParametersStorage.highlightPostTag }
    set { searchParametersStorage.highlightPostTag = newValue }
  }
  public var snippetEllipsisText: String? {
    get { searchParametersStorage.snippetEllipsisText }
    set { searchParametersStorage.snippetEllipsisText = newValue }
  }
  public var restrictHighlightAndSnippetArrays: Bool? {
    get { searchParametersStorage.restrictHighlightAndSnippetArrays }
    set { searchParametersStorage.restrictHighlightAndSnippetArrays = newValue }
  }
  public var page: Int? {
    get { searchParametersStorage.page }
    set { searchParametersStorage.page = newValue }
  }
  public var hitsPerPage: Int? {
    get { searchParametersStorage.hitsPerPage }
    set { searchParametersStorage.hitsPerPage = newValue }
  }
  public var offset: Int? {
    get { searchParametersStorage.offset }
    set { searchParametersStorage.offset = newValue }
  }
  public var length: Int? {
    get { searchParametersStorage.length }
    set { searchParametersStorage.length = newValue }
  }
  public var minWordSizeFor1Typo: Int? {
    get { searchParametersStorage.minWordSizeFor1Typo }
    set { searchParametersStorage.minWordSizeFor1Typo = newValue }
  }
  public var minWordSizeFor2Typos: Int? {
    get { searchParametersStorage.minWordSizeFor2Typos }
    set { searchParametersStorage.minWordSizeFor2Typos = newValue }
  }
  public var typoTolerance: TypoTolerance? {
    get { searchParametersStorage.typoTolerance }
    set { searchParametersStorage.typoTolerance = newValue }
  }
  public var allowTyposOnNumericTokens: Bool? {
    get { searchParametersStorage.allowTyposOnNumericTokens }
    set { searchParametersStorage.allowTyposOnNumericTokens = newValue }
  }
  public var disableTypoToleranceOnAttributes: [Attribute]? {
    get { searchParametersStorage.disableTypoToleranceOnAttributes }
    set { searchParametersStorage.disableTypoToleranceOnAttributes = newValue }
  }
  public var aroundLatLng: Point? {
    get { searchParametersStorage.aroundLatLng }
    set { searchParametersStorage.aroundLatLng = newValue }
  }
  public var aroundLatLngViaIP: Bool? {
    get { searchParametersStorage.aroundLatLngViaIP }
    set { searchParametersStorage.aroundLatLngViaIP = newValue }
  }
  public var aroundRadius: AroundRadius? {
    get { searchParametersStorage.aroundRadius }
    set { searchParametersStorage.aroundRadius = newValue }
  }
  public var aroundPrecision: [AroundPrecision]? {
    get { searchParametersStorage.aroundPrecision }
    set { searchParametersStorage.aroundPrecision = newValue }
  }
  public var minimumAroundRadius: Int? {
    get { searchParametersStorage.minimumAroundRadius }
    set { searchParametersStorage.minimumAroundRadius = newValue }
  }
  public var insideBoundingBox: [BoundingBox]? {
    get { searchParametersStorage.insideBoundingBox }
    set { searchParametersStorage.insideBoundingBox = newValue }
  }
  public var insidePolygon: [Polygon]? {
    get { searchParametersStorage.insidePolygon }
    set { searchParametersStorage.insidePolygon = newValue }
  }
  public var ignorePlurals: LanguageFeature? {
    get { searchParametersStorage.ignorePlurals }
    set { searchParametersStorage.ignorePlurals = newValue }
  }
  public var removeStopWords: LanguageFeature? {
    get { searchParametersStorage.removeStopWords }
    set { searchParametersStorage.removeStopWords = newValue }
  }
  public var queryLanguages: [Language]? {
    get { searchParametersStorage.queryLanguages }
    set { searchParametersStorage.queryLanguages = newValue }
  }
  public var naturalLanguages: [Language]? {
    get { searchParametersStorage.naturalLanguages }
    set { searchParametersStorage.naturalLanguages = newValue }
  }
  public var decompoundQuery: Bool? {
    get { searchParametersStorage.decompoundQuery }
    set { searchParametersStorage.decompoundQuery = newValue }
  }
  public var enableRules: Bool? {
    get { searchParametersStorage.enableRules }
    set { searchParametersStorage.enableRules = newValue }
  }
  public var ruleContexts: [String]? {
    get { searchParametersStorage.ruleContexts }
    set { searchParametersStorage.ruleContexts = newValue }
  }
  public var enablePersonalization: Bool? {
    get { searchParametersStorage.enablePersonalization }
    set { searchParametersStorage.enablePersonalization = newValue }
  }
  public var personalizationImpact: Int? {
    get { searchParametersStorage.personalizationImpact }
    set { searchParametersStorage.personalizationImpact = newValue }
  }
  public var userToken: UserToken? {
    get { searchParametersStorage.userToken }
    set { searchParametersStorage.userToken = newValue }
  }
  public var queryType: QueryType? {
    get { searchParametersStorage.queryType }
    set { searchParametersStorage.queryType = newValue }
  }
  public var removeWordsIfNoResults: RemoveWordIfNoResults? {
    get { searchParametersStorage.removeWordsIfNoResults }
    set { searchParametersStorage.removeWordsIfNoResults = newValue }
  }
  public var advancedSyntax: Bool? {
    get { searchParametersStorage.advancedSyntax }
    set { searchParametersStorage.advancedSyntax = newValue }
  }
  public var optionalWords: [String]? {
    get { searchParametersStorage.optionalWords }
    set { searchParametersStorage.optionalWords = newValue }
  }
  public var disableExactOnAttributes: [Attribute]? {
    get { searchParametersStorage.disableExactOnAttributes }
    set { searchParametersStorage.disableExactOnAttributes = newValue }
  }
  public var exactOnSingleWordQuery: ExactOnSingleWordQuery? {
    get { searchParametersStorage.exactOnSingleWordQuery }
    set { searchParametersStorage.exactOnSingleWordQuery = newValue }
  }
  public var alternativesAsExact: [AlternativesAsExact]? {
    get { searchParametersStorage.alternativesAsExact }
    set { searchParametersStorage.alternativesAsExact = newValue }
  }
  public var advancedSyntaxFeatures: [AdvancedSyntaxFeatures]? {
    get { searchParametersStorage.advancedSyntaxFeatures }
    set { searchParametersStorage.advancedSyntaxFeatures = newValue }
  }
  public var distinct: Distinct? {
    get { searchParametersStorage.distinct }
    set { searchParametersStorage.distinct = newValue }
  }
  public var getRankingInfo: Bool? {
    get { searchParametersStorage.getRankingInfo }
    set { searchParametersStorage.getRankingInfo = newValue }
  }
  public var clickAnalytics: Bool? {
    get { searchParametersStorage.clickAnalytics }
    set { searchParametersStorage.clickAnalytics = newValue }
  }
  public var analytics: Bool? {
    get { searchParametersStorage.analytics }
    set { searchParametersStorage.analytics = newValue }
  }
  public var analyticsTags: [String]? {
    get { searchParametersStorage.analyticsTags }
    set { searchParametersStorage.analyticsTags = newValue }
  }
  public var synonyms: Bool? {
    get { searchParametersStorage.synonyms }
    set { searchParametersStorage.synonyms = newValue }
  }
  public var replaceSynonymsInHighlight: Bool? {
    get { searchParametersStorage.replaceSynonymsInHighlight }
    set { searchParametersStorage.replaceSynonymsInHighlight = newValue }
  }
  public var minProximity: Int? {
    get { searchParametersStorage.minProximity }
    set { searchParametersStorage.minProximity = newValue }
  }
  public var responseFields: [ResponseField]? {
    get { searchParametersStorage.responseFields }
    set { searchParametersStorage.responseFields = newValue }
  }
  public var maxFacetHits: Int? {
    get { searchParametersStorage.maxFacetHits }
    set { searchParametersStorage.maxFacetHits = newValue }
  }
  public var percentileComputation: Bool? {
    get { searchParametersStorage.percentileComputation }
    set { searchParametersStorage.percentileComputation = newValue }
  }
  public var attributeCriteriaComputedByMinProximity: Bool? {
    get { searchParametersStorage.attributeCriteriaComputedByMinProximity }
    set { searchParametersStorage.attributeCriteriaComputedByMinProximity = newValue }
  }
  public var enableABTest: Bool? {
    get { searchParametersStorage.enableABTest }
    set { searchParametersStorage.enableABTest = newValue }
  }
  public var explainModules: [ExplainModule]? {
    get { searchParametersStorage.explainModules }
    set { searchParametersStorage.explainModules = newValue }
  }
  public var relevancyStrictness: Int? {
    get { searchParametersStorage.relevancyStrictness }
    set { searchParametersStorage.relevancyStrictness = newValue }
  }
  public var enableReRanking: Bool? {
    get { searchParametersStorage.enableReRanking }
    set { searchParametersStorage.enableReRanking = newValue }
  }
}

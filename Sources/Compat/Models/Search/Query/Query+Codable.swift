//
//  Query+Codable.swift
//  
//
//  Created by Vladislav Fitc on 20/03/2020.
//
// swiftlint:disable function_body_length

import Foundation

extension SearchParametersStorage: Codable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    query = try? container.decodeIfPresent(forKey: .query)
    attributesToRetrieve = try container.decodeIfPresent(forKey: .attributesToRetrieve)
    restrictSearchableAttributes = try container.decodeIfPresent(forKey: .restrictSearchableAttributes)
    filters = try container.decodeIfPresent(forKey: .filters)
    facetFilters = try container.decodeIfPresent(forKey: .facetFilters)
    optionalFilters = try container.decodeIfPresent(forKey: .optionalFilters)
    numericFilters = try container.decodeIfPresent(forKey: .numericFilters)
    tagFilters = try container.decodeIfPresent(forKey: .tagFilters)
    sumOrFiltersScores = try container.decodeIfPresent(forKey: .sumOrFiltersScores)
    facets = try container.decodeIfPresent(forKey: .facets)
    maxValuesPerFacet = try container.decodeIfPresent(forKey: .maxValuesPerFacet)
    facetingAfterDistinct = try container.decodeIfPresent(forKey: .facetingAfterDistinct)
    sortFacetsBy = try container.decodeIfPresent(forKey: .sortFacetsBy)
    attributesToHighlight = try container.decodeIfPresent(forKey: .attributesToHighlight)
    attributesToSnippet = try container.decodeIfPresent(forKey: .attributesToSnippet)
    highlightPreTag = try container.decodeIfPresent(forKey: .highlightPreTag)
    highlightPostTag = try container.decodeIfPresent(forKey: .highlightPostTag)
    snippetEllipsisText = try container.decodeIfPresent(forKey: .snippetEllipsisText)
    restrictHighlightAndSnippetArrays = try container.decodeIfPresent(forKey: .restrictHighlightAndSnippetArrays)
    page = try container.decodeIfPresent(forKey: .page)
    hitsPerPage = try container.decodeIfPresent(forKey: .hitsPerPage)
    offset = try container.decodeIfPresent(forKey: .offset)
    length = try container.decodeIfPresent(forKey: .length)
    minWordSizeFor1Typo = try container.decodeIfPresent(forKey: .minWordSizeFor1Typo)
    minWordSizeFor2Typos = try container.decodeIfPresent(forKey: .minWordSizeFor2Typos)
    typoTolerance = try container.decodeIfPresent(forKey: .typoTolerance)
    allowTyposOnNumericTokens = try container.decodeIfPresent(forKey: .allowTyposOnNumericTokens)
    disableTypoToleranceOnAttributes = try container.decodeIfPresent(forKey: .disableTypoToleranceOnAttributes)
    aroundLatLng = try container.decodeIfPresent(forKey: .aroundLatLng)
    aroundLatLngViaIP = try container.decodeIfPresent(forKey: .aroundLatLngViaIP)
    aroundRadius = try container.decodeIfPresent(forKey: .aroundRadius)
    aroundPrecision = try container.decodeIfPresent(forKey: .aroundPrecision)
    minimumAroundRadius = try container.decodeIfPresent(forKey: .minimumAroundRadius)
    insideBoundingBox = try container.decodeIfPresent(forKey: .insideBoundingBox)
    insidePolygon = try container.decodeIfPresent(forKey: .insidePolygon)
    ignorePlurals = try container.decodeIfPresent(forKey: .ignorePlurals)
    removeStopWords = try container.decodeIfPresent(forKey: .removeStopWords)
    queryLanguages = try container.decodeIfPresent(forKey: .queryLanguages)
    decompoundQuery = try container.decodeIfPresent(forKey: .decompoundQuery)
    enableRules = try container.decodeIfPresent(forKey: .enableRules)
    ruleContexts = try container.decodeIfPresent(forKey: .ruleContexts)
    enablePersonalization = try container.decodeIfPresent(forKey: .enablePersonalization)
    personalizationImpact = try container.decodeIfPresent(forKey: .personalizationImpact)
    userToken = try container.decodeIfPresent(forKey: .userToken)
    queryType = try container.decodeIfPresent(forKey: .queryType)
    removeWordsIfNoResults = try container.decodeIfPresent(forKey: .removeWordsIfNoResults)
    advancedSyntax = try container.decodeIfPresent(forKey: .advancedSyntax)
    advancedSyntaxFeatures = try container.decodeIfPresent(forKey: .advancedSyntaxFeatures)
    optionalWords = try container.decodeIfPresent(forKey: .optionalWords)
    disableExactOnAttributes = try container.decodeIfPresent(forKey: .disableExactOnAttributes)
    exactOnSingleWordQuery = try container.decodeIfPresent(forKey: .exactOnSingleWordQuery)
    alternativesAsExact = try container.decodeIfPresent(forKey: .alternativesAsExact)
    distinct = try container.decodeIfPresent(forKey: .distinct)
    getRankingInfo = try container.decodeIfPresent(forKey: .getRankingInfo)
    clickAnalytics = try container.decodeIfPresent(forKey: .clickAnalytics)
    analytics = try container.decodeIfPresent(forKey: .analytics)
    analyticsTags = try container.decodeIfPresent(forKey: .analyticsTags)
    synonyms = try container.decodeIfPresent(forKey: .synonyms)
    replaceSynonymsInHighlight = try container.decodeIfPresent(forKey: .replaceSynonymsInHighlight)
    minProximity = try container.decodeIfPresent(forKey: .minProximity)
    responseFields = try container.decodeIfPresent(forKey: .responseFields)
    maxFacetHits = try container.decodeIfPresent(forKey: .maxFacetHits)
    percentileComputation = try container.decodeIfPresent(forKey: .percentileComputation)
    similarQuery = try container.decodeIfPresent(forKey: .similarQuery)
    enableABTest = try container.decodeIfPresent(forKey: .enableABTest)
    explainModules = try container.decodeIfPresent(forKey: .explainModules)
    naturalLanguages = try container.decodeIfPresent(forKey: .naturalLanguages)
    relevancyStrictness = try container.decodeIfPresent(forKey: .relevancyStrictness)
    enableReRanking = try container.decodeIfPresent(forKey: .enableReRanking)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(query, forKey: .query)
    try container.encodeIfPresent(attributesToRetrieve, forKey: .attributesToRetrieve)
    try container.encodeIfPresent(restrictSearchableAttributes, forKey: .restrictSearchableAttributes)
    try container.encodeIfPresent(filters, forKey: .filters)
    try container.encodeIfPresent(facetFilters, forKey: .facetFilters)
    try container.encodeIfPresent(optionalFilters, forKey: .optionalFilters)
    try container.encodeIfPresent(numericFilters, forKey: .numericFilters)
    try container.encodeIfPresent(tagFilters, forKey: .tagFilters)
    try container.encodeIfPresent(sumOrFiltersScores, forKey: .sumOrFiltersScores)
    try container.encodeIfPresent(facets, forKey: .facets)
    try container.encodeIfPresent(maxValuesPerFacet, forKey: .maxValuesPerFacet)
    try container.encodeIfPresent(facetingAfterDistinct, forKey: .facetingAfterDistinct)
    try container.encodeIfPresent(sortFacetsBy, forKey: .sortFacetsBy)
    try container.encodeIfPresent(attributesToHighlight, forKey: .attributesToHighlight)
    try container.encodeIfPresent(attributesToSnippet, forKey: .attributesToSnippet)
    try container.encodeIfPresent(highlightPreTag, forKey: .highlightPreTag)
    try container.encodeIfPresent(highlightPostTag, forKey: .highlightPostTag)
    try container.encodeIfPresent(snippetEllipsisText, forKey: .snippetEllipsisText)
    try container.encodeIfPresent(restrictHighlightAndSnippetArrays, forKey: .restrictHighlightAndSnippetArrays)
    try container.encodeIfPresent(page, forKey: .page)
    try container.encodeIfPresent(hitsPerPage, forKey: .hitsPerPage)
    try container.encodeIfPresent(offset, forKey: .offset)
    try container.encodeIfPresent(length, forKey: .length)
    try container.encodeIfPresent(minWordSizeFor1Typo, forKey: .minWordSizeFor1Typo)
    try container.encodeIfPresent(minWordSizeFor2Typos, forKey: .minWordSizeFor2Typos)
    try container.encodeIfPresent(typoTolerance, forKey: .typoTolerance)
    try container.encodeIfPresent(allowTyposOnNumericTokens, forKey: .allowTyposOnNumericTokens)
    try container.encodeIfPresent(disableTypoToleranceOnAttributes, forKey: .disableTypoToleranceOnAttributes)
    try container.encodeIfPresent(aroundLatLng, forKey: .aroundLatLng)
    try container.encodeIfPresent(aroundLatLngViaIP, forKey: .aroundLatLngViaIP)
    try container.encodeIfPresent(aroundRadius, forKey: .aroundRadius)
    try container.encodeIfPresent(aroundPrecision, forKey: .aroundPrecision)
    try container.encodeIfPresent(minimumAroundRadius, forKey: .minimumAroundRadius)
    try container.encodeIfPresent(insideBoundingBox, forKey: .insideBoundingBox)
    try container.encodeIfPresent(insidePolygon, forKey: .insidePolygon)
    try container.encodeIfPresent(ignorePlurals, forKey: .ignorePlurals)
    try container.encodeIfPresent(removeStopWords, forKey: .removeStopWords)
    try container.encodeIfPresent(queryLanguages, forKey: .queryLanguages)
    try container.encodeIfPresent(decompoundQuery, forKey: .decompoundQuery)
    try container.encodeIfPresent(enableRules, forKey: .enableRules)
    try container.encodeIfPresent(ruleContexts, forKey: .ruleContexts)
    try container.encodeIfPresent(enablePersonalization, forKey: .enablePersonalization)
    try container.encodeIfPresent(personalizationImpact, forKey: .personalizationImpact)
    try container.encodeIfPresent(userToken, forKey: .userToken)
    try container.encodeIfPresent(queryType, forKey: .queryType)
    try container.encodeIfPresent(removeWordsIfNoResults, forKey: .removeWordsIfNoResults)
    try container.encodeIfPresent(advancedSyntax, forKey: .advancedSyntax)
    try container.encodeIfPresent(advancedSyntaxFeatures, forKey: .advancedSyntaxFeatures)
    try container.encodeIfPresent(optionalWords, forKey: .optionalWords)
    try container.encodeIfPresent(disableExactOnAttributes, forKey: .disableExactOnAttributes)
    try container.encodeIfPresent(exactOnSingleWordQuery, forKey: .exactOnSingleWordQuery)
    try container.encodeIfPresent(alternativesAsExact, forKey: .alternativesAsExact)
    try container.encodeIfPresent(distinct, forKey: .distinct)
    try container.encodeIfPresent(getRankingInfo, forKey: .getRankingInfo)
    try container.encodeIfPresent(clickAnalytics, forKey: .clickAnalytics)
    try container.encodeIfPresent(analytics, forKey: .analytics)
    try container.encodeIfPresent(analyticsTags, forKey: .analyticsTags)
    try container.encodeIfPresent(synonyms, forKey: .synonyms)
    try container.encodeIfPresent(replaceSynonymsInHighlight, forKey: .replaceSynonymsInHighlight)
    try container.encodeIfPresent(minProximity, forKey: .minProximity)
    try container.encodeIfPresent(responseFields, forKey: .responseFields)
    try container.encodeIfPresent(maxFacetHits, forKey: .maxFacetHits)
    try container.encodeIfPresent(percentileComputation, forKey: .percentileComputation)
    try container.encodeIfPresent(similarQuery, forKey: .similarQuery)
    try container.encodeIfPresent(enableABTest, forKey: .enableABTest)
    try container.encodeIfPresent(explainModules, forKey: .explainModules)
    try container.encodeIfPresent(naturalLanguages, forKey: .naturalLanguages)
    try container.encodeIfPresent(relevancyStrictness, forKey: .relevancyStrictness)
    try container.encodeIfPresent(enableReRanking, forKey: .enableReRanking)
  }

  enum CodingKeys: String, CodingKey, CaseIterable {
    case query
    case attributesToRetrieve
    case restrictSearchableAttributes
    case filters
    case facetFilters
    case optionalFilters
    case numericFilters
    case tagFilters
    case sumOrFiltersScores
    case facets
    case maxValuesPerFacet
    case facetingAfterDistinct
    case sortFacetsBy = "sortFacetValuesBy"
    case attributesToHighlight
    case attributesToSnippet
    case highlightPreTag
    case highlightPostTag
    case snippetEllipsisText
    case restrictHighlightAndSnippetArrays
    case page
    case hitsPerPage
    case offset
    case length
    case minWordSizeFor1Typo = "minWordSizefor1Typo"
    case minWordSizeFor2Typos = "minWordSizefor2Typos"
    case typoTolerance
    case allowTyposOnNumericTokens
    case disableTypoToleranceOnAttributes
    case aroundLatLng
    case aroundLatLngViaIP
    case aroundRadius
    case aroundPrecision
    case minimumAroundRadius
    case insideBoundingBox
    case insidePolygon
    case ignorePlurals
    case removeStopWords
    case queryLanguages
    case decompoundQuery
    case enableRules
    case ruleContexts
    case enablePersonalization
    case personalizationImpact
    case userToken
    case queryType
    case removeWordsIfNoResults
    case advancedSyntax
    case advancedSyntaxFeatures
    case optionalWords
    case disableExactOnAttributes
    case exactOnSingleWordQuery
    case alternativesAsExact
    case distinct
    case getRankingInfo
    case clickAnalytics
    case analytics
    case analyticsTags
    case synonyms
    case replaceSynonymsInHighlight
    case minProximity
    case responseFields
    case maxFacetHits
    case percentileComputation
    case similarQuery
    case enableABTest
    case explainModules
    case naturalLanguages
    case relevancyStrictness
    case enableReRanking
  }

}
// swiftlint:enable function_body_length

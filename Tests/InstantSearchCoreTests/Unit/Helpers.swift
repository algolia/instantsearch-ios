import Foundation
import AlgoliaSearch
@testable import InstantSearchCore

typealias JSON = [String: AnyCodable]

func safeIndexName(_ name: String) -> String {
  var targetName = Bundle.main.object(forInfoDictionaryKey: "BUILD_TARGET_NAME") as? String ?? ""
  targetName = targetName.replacingOccurrences(of: " ", with: "-")

  let rawName: String
  if let travisBuild = ProcessInfo.processInfo.environment["TRAVIS_JOB_NUMBER"] {
    rawName = "\(name)_travis_\(travisBuild)"
  } else if let bitriseBuild = Bundle.main.object(forInfoDictionaryKey: "BITRISE_BUILD_NUMBER") as? String {
    rawName = "\(name)_bitrise_\(bitriseBuild)_\(targetName)"
  } else {
    rawName = name
  }
  return rawName
}

func average(values: [Double]) -> Double {
  return values.reduce(0, +) / Double(values.count)
}

/// Generate a new host name in the `algolia.biz` domain.
/// The DNS lookup for any host in the `algolia.biz` domain will time-out.
/// Generating a new host name every time avoids any system-level or network-level caching side effect.
///
func uniqueAlgoliaBizHost() -> String {
  return "swift-\(UInt32(NSDate().timeIntervalSince1970)).algolia.biz"
}

func makeJSONHit(_ value: String) -> [String: AnyCodable] {
  return ["value": AnyCodable(value)]
}

// swiftlint:disable:next function_parameter_count
func makeSearchResponse(hits: [SearchHit] = [],
                        page: Int = 0,
                        nbHits: Int = 0,
                        hitsPerPage: Int = 20,
                        nbPages: Int = 1,
                        processingTimeMS: Int = 0,
                        query: String = "",
                        params: String = "") -> SearchResponse<SearchHit> {
  return SearchResponse(page: page,
                        nbHits: nbHits,
                        nbPages: nbPages,
                        hitsPerPage: hitsPerPage,
                        hits: hits,
                        query: query,
                        params: params)
    .set(\.processingTimeMS, to: processingTimeMS)
}

func makeSearchResponse<Record: Encodable>(records: [Record]) -> SearchResponse<SearchHit> {
  let hits: [SearchHit] = records.compactMap { record in
    guard let json = encodeToJSON(record) else { return nil }
    return Hit(object: json)
  }
  return makeSearchResponse(hits: hits)
}

func makeSearchResponses(_ responses: [SearchResponse<SearchHit>]) -> SearchResponses<SearchHit> {
  return SearchResponses(results: responses.map { .searchResponse($0) })
}

func makeFacetSearchResponse(facetHits: [InstantSearchCore.FacetHits],
                             processingTimeMS: Int = 1,
                             exhaustiveFacetsCount: Bool = true) -> SearchForFacetValuesResponse {
  let searchFacetHits = facetHits.map { AlgoliaSearch.FacetHits(value: $0.value, highlighted: $0.highlighted, count: $0.count) }
  return SearchForFacetValuesResponse(facetHits: searchFacetHits,
                                      exhaustiveFacetsCount: exhaustiveFacetsCount,
                                      processingTimeMS: processingTimeMS)
}

private func encodeToJSON<Record: Encodable>(_ record: Record) -> [String: AnyCodable]? {
  let encoder = JSONEncoder()
  guard let data = try? encoder.encode(record) else { return nil }
  return try? JSONDecoder().decode([String: AnyCodable].self, from: data)
}

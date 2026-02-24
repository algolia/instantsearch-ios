import Foundation
@testable import InstantSearchCore

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

func makeJSONHit(_ value: String) -> JSON {
  return ["value": AnyCodable(value)]
}

func makeSearchResponse(hits: [SearchHit] = [],
                        page: Int = 0,
                        nbHits: Int = 0,
                        hitsPerPage: Int = 20,
                        nbPages: Int = 1,
                        processingTimeMS: Int = 0,
                        query: String = "",
                        params: String = "") -> SearchResponse {
  let encoder = JSONEncoder()
  let hitsData = (try? encoder.encode(hits)) ?? Data()
  let hitsJSONArray = (try? JSONSerialization.jsonObject(with: hitsData, options: [])) as? [Any] ?? []
  let payload: [String: Any] = [
    "hits": hitsJSONArray,
    "page": page,
    "nbHits": nbHits,
    "hitsPerPage": hitsPerPage,
    "nbPages": nbPages,
    "processingTimeMS": processingTimeMS,
    "query": query,
    "params": params
  ]
  let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
  return try! JSONDecoder().decode(SearchResponse.self, from: data)
}

func makeSearchResponse<Record: Encodable>(records: [Record]) -> SearchResponse {
  let hits: [SearchHit] = records.compactMap { record in
    guard let json = encodeToJSON(record) else { return nil }
    return Hit(object: json)
  }
  return makeSearchResponse(hits: hits)
}

func makeSearchResponses(_ responses: [SearchResponse]) -> SearchResponses<SearchHit> {
  return SearchResponses(results: responses.map { .searchResponse($0) })
}

func makeFacetSearchResponse(facetHits: [FacetHits],
                             processingTimeMS: Int = 1,
                             exhaustiveFacetsCount: Bool = true) -> FacetSearchResponse {
  let hitsPayload = facetHits.map { hit in
    [
      "value": hit.value,
      "highlighted": hit.highlighted,
      "count": hit.count
    ]
  }
  let payload: [String: Any] = [
    "facetHits": hitsPayload,
    "exhaustiveFacetsCount": exhaustiveFacetsCount,
    "processingTimeMS": processingTimeMS
  ]
  let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
  return try! JSONDecoder().decode(FacetSearchResponse.self, from: data)
}

private func encodeToJSON<Record: Encodable>(_ record: Record) -> JSON? {
  let encoder = JSONEncoder()
  guard let data = try? encoder.encode(record) else { return nil }
  return try? JSONDecoder().decode(JSON.self, from: data)
}

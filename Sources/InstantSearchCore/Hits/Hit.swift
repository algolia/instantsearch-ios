//
//  Hit.swift
//  InstantSearchCore
//

import AlgoliaCore
import Foundation
import AlgoliaSearch

/// A generic hit wrapper for Algolia search results.
public struct Hit<Record: Codable>: Codable {
  public let object: Record
  public let objectID: String
  public let highlightResult: [String: SearchHighlightResult]?
  public let snippetResult: [String: SearchSnippetResult]?
  public let rankingInfo: SearchRankingInfo?
  public let distinctSeqID: Int?

  public init(object: Record,
              objectID: String? = nil,
              highlightResult: [String: SearchHighlightResult]? = nil,
              snippetResult: [String: SearchSnippetResult]? = nil,
              rankingInfo: SearchRankingInfo? = nil,
              distinctSeqID: Int? = nil) {
    self.object = object
    self.objectID = objectID ?? Hit.extractObjectID(from: object)
    self.highlightResult = highlightResult
    self.snippetResult = snippetResult
    self.rankingInfo = rankingInfo
    self.distinctSeqID = distinctSeqID
  }

  public init(from decoder: Decoder) throws {
    let searchHit = try AlgoliaSearch.Hit(from: decoder)
    objectID = searchHit.objectID
    highlightResult = searchHit.highlightResult
    snippetResult = searchHit.snippetResult
    rankingInfo = searchHit.rankingInfo
    distinctSeqID = searchHit.distinctSeqID

    var payload = searchHit.additionalProperties
    payload["objectID"] = AlgoliaCore.AnyCodable(searchHit.objectID)
    if let highlightResult {
      payload["_highlightResult"] = AlgoliaCore.AnyCodable(highlightResult)
    }
    if let snippetResult {
      payload["_snippetResult"] = AlgoliaCore.AnyCodable(snippetResult)
    }
    if let rankingInfo {
      payload["_rankingInfo"] = AlgoliaCore.AnyCodable(rankingInfo)
    }
    if let distinctSeqID {
      payload["_distinctSeqID"] = AlgoliaCore.AnyCodable(distinctSeqID)
    }

    let data = try JSONEncoder().encode(payload)
    object = try JSONDecoder().decode(Record.self, from: data)
  }

  public func encode(to encoder: Encoder) throws {
    var searchHit = AlgoliaSearch.Hit(objectID: objectID,
                               highlightResult: highlightResult,
                               snippetResult: snippetResult,
                               rankingInfo: rankingInfo,
                               distinctSeqID: distinctSeqID)
    if var json = Hit.encodeToJSON(object) {
      // Remove keys that are already handled by AlgoliaSearch.Hit to avoid duplicates
      json.removeValue(forKey: "objectID")
      json.removeValue(forKey: "_highlightResult")
      json.removeValue(forKey: "_snippetResult")
      json.removeValue(forKey: "_rankingInfo")
      json.removeValue(forKey: "_distinctSeqID")
      searchHit.additionalProperties = json
    }
    try searchHit.encode(to: encoder)
  }
}

extension Hit: Equatable where Record: Equatable {}
extension Hit: Hashable where Record: Hashable {}

private extension Hit {
  static func extractObjectID(from record: Record) -> String {
    if let indexable = record as? Indexable {
      return indexable.objectID
    }
    if let json = record as? [String: AlgoliaCore.AnyCodable], let objectID = json["objectID"]?.value as? String {
      return objectID
    }
    return ""
  }

  static func encodeToJSON(_ record: Record) -> [String: AlgoliaCore.AnyCodable]? {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(record) else { return nil }
    return try? JSONDecoder().decode([String: AlgoliaCore.AnyCodable].self, from: data)
  }
}

//
//  SearchStats.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 14/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public struct SearchStats: Codable {

  enum CodingKeys: String, CodingKey {
    case totalHitsCount = "nbHits"
    case page
    case pagesCount = "nbPages"
    case hitsPerPage
    case processingTimeMS
    case query
    case queryID
  }

  /// Number of hits per page.
  public let hitsPerPage: Int

  /// Total number of hits.
  public let totalHitsCount: Int

  /// Total number of pages.
  public let pagesCount: Int

  /// Last returned page.
  public let page: Int

  /// Processing time of the last query (in ms).
  public let processingTimeMS: Int

  /// Query text that produced these results.
  public let query: String?

  /// Query ID that produced these results.
  /// Mandatory when reporting click and conversion events
  /// Only reported when `clickAnalytics=true` in the `Query`
  ///
  public let queryID: QueryID?

  init() {
    self.hitsPerPage = 0
    self.totalHitsCount = 0
    self.pagesCount = 0
    self.page = 0
    self.processingTimeMS = 0
    self.query = nil
    self.queryID = nil
  }

  init(totalHitsCount: Int,
       hitsPerPage: Int? = nil,
       pagesCount: Int = 1,
       page: Int = 0,
       processingTimeMS: Int,
       query: String? = nil,
       queryID: QueryID? = nil) {
    self.totalHitsCount = totalHitsCount
    self.hitsPerPage = hitsPerPage ?? totalHitsCount
    self.pagesCount = pagesCount
    self.page = page
    self.processingTimeMS = processingTimeMS
    self.query = query
    self.queryID = queryID
  }

  public init(from decoder: Decoder) throws {

    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.totalHitsCount = try container.decode(Int.self, forKey: .totalHitsCount)
    self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
    self.pagesCount = try container.decodeIfPresent(Int.self, forKey: .pagesCount) ?? 1
    self.hitsPerPage = try container.decodeIfPresent(Int.self, forKey: .hitsPerPage) ?? 20
    self.processingTimeMS = try container.decode(Int.self, forKey: .processingTimeMS)
    self.query = try container.decodeIfPresent(String.self, forKey: .query)
    self.queryID = try container.decodeIfPresent(QueryID.self, forKey: .queryID)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(totalHitsCount, forKey: .totalHitsCount)
    try container.encode(page, forKey: .page)
    try container.encode(pagesCount, forKey: .pagesCount)
    try container.encode(hitsPerPage, forKey: .hitsPerPage)
    try container.encode(processingTimeMS, forKey: .processingTimeMS)
    try container.encodeIfPresent(query, forKey: .query)
    try container.encodeIfPresent(queryID, forKey: .queryID)

  }

}

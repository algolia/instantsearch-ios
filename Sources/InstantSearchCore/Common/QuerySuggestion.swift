//
//  QuerySuggestion.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

/// Search query suggestion item
public struct QuerySuggestion {

  /// The suggested search term
  public let query: String

  /// The suggested search term with tagged highlighted part
  public let highlighted: String?

  /// The popularity score of the search term
  public let popularity: Int

}

extension QuerySuggestion: Codable {

  enum CodingKeys: String, CodingKey {
    case query
    case popularity
    case highlightResult = "_highlightResult"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let highlightResult = try? container.decode(TreeModel<HighlightResult>.self, forKey: .highlightResult) {
      highlighted = highlightResult["query"]?.value?.value.taggedString.input
    } else {
      highlighted = nil
    }
    self.query = try container.decode(String.self, forKey: .query)
    self.popularity = try container.decode(Int.self, forKey: .popularity)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(query, forKey: .query)
    try container.encode(popularity, forKey: .popularity)
  }

}

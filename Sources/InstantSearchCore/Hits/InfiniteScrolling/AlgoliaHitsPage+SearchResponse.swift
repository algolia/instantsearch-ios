//
//  AlgoliaHitsPage+SearchResponse.swift
//  
//
//  Created by Vladislav Fitc on 28/04/2023.
//

import Foundation

extension AlgoliaHitsPage where Item: Decodable {

  /// Initializes a new instance of `AlgoliaHitsPage` with the provided `SearchRespons`
  ///
  /// - Parameters:
  ///     - searchResponse: An instance of `SearchResponse` object
  ///
  /// - Throws: `AlgoliaHitsPageSearchReponseError` instance
  init(_ searchResponse: SearchResponse) throws {
    guard let page = searchResponse.page else {
      throw AlgoliaHitsPageSearchReponseError.missingPage
    }
    guard let nbPages = searchResponse.nbPages else {
      throw AlgoliaHitsPageSearchReponseError.missingNbPages
    }
    let hits: [Item]
    do {
      hits = try searchResponse.extractHits()
    } catch let error {
      throw AlgoliaHitsPageSearchReponseError.hitsExtractionError(error)
    }
    self.init(page: page,
              hits: hits,
              hasPrevious: page > 0,
              hasNext: page < nbPages-1)
  }

}

/// Errors which may happen during construction of AlgoliaHitsPage with SearchResponse
public enum AlgoliaHitsPageSearchReponseError: LocalizedError {

  case missingPage
  case missingNbPages
  case hitsExtractionError(Error)

  public var errorDescription: String? {
    switch self {
    case .missingPage:
      return "nil `page` value in the search response"
    case .missingNbPages:
      return "nil `nbPages` value in the search response"
    case let .hitsExtractionError(error):
      return "hits decoding error from the search response: \(error.localizedDescription)"
    }
  }

}

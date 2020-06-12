//
//  Logging.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 11/02/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

extension Logger {

  static func error(prefix: String = "", _ error: Error) {
    let errorMessage: String
    if let decodingError = error as? DecodingError {
      errorMessage = decodingError.prettyDescription
    } else {
      errorMessage = "\(error)"
    }
    self.error("\(prefix) \(errorMessage)")
  }

}

extension Logger {

  enum HitsDecoding {

    static func failure(hitsInteractor: AnyHitsInteractor, error: Error) {
      Logger.error(prefix: "\(hitsInteractor): ", error)
    }

  }

}

extension Logger {

  enum Results {

    static func failure(searcher: Searcher, indexName: IndexName, _ error: Error) {
      Logger.error(prefix: "\(searcher): error - index: \(indexName.rawValue)", error)
    }

    static func success(searcher: Searcher, indexName: IndexName, results: SearchStatsConvertible) {
      let stats = results.searchStats
      let query = stats.query ?? ""
      let message = "\(searcher): received results - index: \(indexName.rawValue) query: \"\(query)\" hits count: \(stats.totalHitsCount) in \(stats.processingTimeMS)ms"
      Logger.info(message)
    }

  }

}

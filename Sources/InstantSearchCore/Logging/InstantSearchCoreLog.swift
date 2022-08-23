//
//  InstantSearchCoreLog.swift
//  
//
//  Created by Vladislav Fitc on 11/06/2020.
//

import Foundation
import Logging
#if !InstantSearchCocoaPods
import struct InstantSearchInsights.Logs
import protocol InstantSearchInsights.LogCollectable
#endif

struct InstantSearchCoreLog: LogCollectable {

  static var logger: Logging.Logger = {
    NotificationCenter.default.addObserver(forName: Logs.logLevelChangeNotficationName, object: nil, queue: .main) { notification in
      if let logLevel = notification.userInfo?["logLevel"] as? LogLevel {
        InstantSearchCoreLog.logger.logLevel = logLevel.swiftLogLevel
      }
    }
    var logger = Logging.Logger(label: "InstantSearchCore")
    logger.logLevel = Logs.logSeverityLevel.swiftLogLevel
    return logger
  }()

}

extension InstantSearchCoreLog {

  static func error(prefix: String = "", _ error: Error) {
    let errorMessage: String
    if let decodingError = error as? DecodingError {
      errorMessage = decodingError.prettyDescription
    } else {
      errorMessage = "\(error)"
    }
    logger.error("\(prefix) \(errorMessage)")
  }

}

extension InstantSearchCoreLog {

  enum HitsDecoding {

    static func failure(hitsInteractor: AnyHitsInteractor, error: Error) {
      logger.error("\(hitsInteractor): \(error)")
    }

  }

}

extension InstantSearchCoreLog {

  enum Results {

    static func failure(searcher: Searcher, indexName: IndexName, _ error: Error) {
      logger.error("\(searcher): error - index: \(indexName.rawValue): \(error)")
    }

    static func success(searcher: Searcher, indexName: IndexName, results: SearchStatsConvertible) {
      let stats = results.searchStats
      let query = stats.query ?? ""
      let message = "\(searcher): received results - index: \(indexName.rawValue) query: \"\(query)\" hits count: \(stats.totalHitsCount) in \(stats.processingTimeMS)ms"
      logger.info("\(message)")
    }

  }

}

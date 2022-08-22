//
//  Log.swift
//  
//
//  Created by Vladislav Fitc on 11/06/2020.
//

import Logging
import Foundation
#if !InstantSearchCocoaPods
import struct InstantSearchInsights.Logs
#endif

struct Log {
  
  static var logger: Logging.Logger = {
    NotificationCenter.default.addObserver(forName: Notification.Name("com.algolia.logLevelChange"), object: nil, queue: .main) { notification in
      if let logLevel = notification.userInfo?["logLevel"] as? LogLevel {
        Log.logger.logLevel = logLevel.swiftLogLevel
      }
    }
    var logger = Logging.Logger(label: "InstantSearchCore")
    logger.logLevel = Logs.logSeverityLevel.swiftLogLevel
    return logger
  }()
  
  static func trace(_ message: String) {
    logger.log(level: .trace, "\(message)")
  }
  
  static func debug(_ message: String) {
    logger.log(level: .debug, "\(message)")
  }
  
  static func info(_ message: String) {
    logger.log(level: .info, "\(message)")
  }
  
  static func notice(_ message: String) {
    logger.log(level: .notice, "\(message)")
  }
  
  static func warning(_ message: String) {
    logger.log(level: .warning, "\(message)")
  }
  
  static func error(_ message: String) {
    logger.log(level: .error, "\(message)")
  }
  
  static func critical(_ message: String) {
    logger.log(level: .critical, "\(message)")
  }
  
}

extension Log {

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

extension Log {

  enum HitsDecoding {

    static func failure(hitsInteractor: AnyHitsInteractor, error: Error) {
      logger.error("\(hitsInteractor): \(error)")
    }

  }

}

extension Log {

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

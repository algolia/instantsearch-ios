//
//  Logger+InstantSearchCore.swift
//  
//
//  Created by Vladislav Fitc on 11/06/2020.
//

import Logging
#if !InstantSearchCocoaPods
import struct InstantSearchInsights.Logger
import enum InstantSearchInsights.LogLevel
import protocol InstantSearchInsights.LogCollector
import protocol InstantSearchInsights.LogService
#endif

public extension Logger {

  struct InstantSearchCore: LogCollector {

    public static var minLogSeverityLevel: LogLevel {

      get {
        return service.minLogSeverityLevel
      }

      set {
        service.minLogSeverityLevel = newValue
      }

    }

    public static var isEnabled: Bool = true

    static var service: LogService = {
      var swiftLog = Logging.Logger(label: "com.algolia.InstantSearchCore")
      swiftLog.logLevel = .info
      swiftLog.info("Default minimal log severity level is info. Change Logger.InstantSearchCore.minLogSeverityLevel value if you want to change it.")
      return swiftLog
    }()

    public static func log(level: LogLevel, message: String) {
      guard Logger.InstantSearchCore.isEnabled else { return }
      service.log(level: level, message: message)
    }

  }

}

typealias InstantSearchCoreLogger = Logger.InstantSearchCore

extension Logger.InstantSearchCore {

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

extension Logger.InstantSearchCore {

  enum HitsDecoding {

    static func failure(hitsInteractor: AnyHitsInteractor, error: Error) {
      Logger.InstantSearchCore.error(prefix: "\(hitsInteractor): ", error)
    }

  }

}

extension Logger.InstantSearchCore {

  enum Results {

    static func failure(searcher: Searcher, indexName: IndexName, _ error: Error) {
      Logger.InstantSearchCore.error(prefix: "\(searcher): error - index: \(indexName.rawValue)", error)
    }

    static func success(searcher: Searcher, indexName: IndexName, results: SearchStatsConvertible) {
      let stats = results.searchStats
      let query = stats.query ?? ""
      let message = "\(searcher): received results - index: \(indexName.rawValue) query: \"\(query)\" hits count: \(stats.totalHitsCount) in \(stats.processingTimeMS)ms"
      Logger.InstantSearchCore.info(message)
    }

  }

}

//
//  Logging.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 11/02/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import Logging
import AlgoliaSearchClientSwift

typealias SwiftLog = Logging.Logger

public struct Logger {

  static var loggingService: Loggable = {
    var swiftLog = SwiftLog(label: "com.algolia.InstantSearch")
    print("InstantSearch: Default minimal log severity level is info. Change Logger.minLogServerityLevel value if you want to change it.")
    swiftLog.logLevel = .info
    return swiftLog
  }()

  public static var minSeverityLevel: LogLevel {
    get {
      return loggingService.minSeverityLevel
    }

    set {
      loggingService.minSeverityLevel = newValue
    }
  }

  private init() {}

  static func trace(_ message: String) {
    loggingService.log(level: .trace, message: message)
  }

  static func debug(_ message: String) {
    loggingService.log(level: .debug, message: message)
  }

  static func info(_ message: String) {
    loggingService.log(level: .info, message: message)
  }

  static func notice(_ message: String) {
    loggingService.log(level: .notice, message: message)
  }

  static func warning(_ message: String) {
    loggingService.log(level: .warning, message: message)
  }

  static func error(_ message: String) {
    loggingService.log(level: .error, message: message)
  }

  static func critical(_ message: String) {
    loggingService.log(level: .critical, message: message)
  }

}

public enum LogLevel {
  case trace, debug, info, notice, warning, error, critical
}

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

extension LogLevel {

  init(swiftLogLevel: SwiftLog.Level) {
    switch swiftLogLevel {
    case .trace: self = .trace
    case .debug: self = .debug
    case .info: self = .info
    case .notice: self = .notice
    case .warning: self = .warning
    case .error: self = .error
    case .critical: self = .critical
    }
  }

  var swiftLogLevel: SwiftLog.Level {
    switch self {
    case .trace: return .trace
    case .debug: return .debug
    case .info: return .info
    case .notice: return .notice
    case .warning: return .warning
    case .error: return .error
    case .critical: return .critical
    }
  }

}

protocol Loggable {

  var minSeverityLevel: LogLevel { get set }

  func log(level: LogLevel, message: String)

}

extension SwiftLog: Loggable {

  var minSeverityLevel: LogLevel {
    get {
      return LogLevel(swiftLogLevel: logLevel)
    }
    set {
      self.logLevel = newValue.swiftLogLevel
    }
  }

  func log(level: LogLevel, message: String) {
    self.log(level: level.swiftLogLevel, SwiftLog.Message(stringLiteral: message), metadata: .none)
  }

}

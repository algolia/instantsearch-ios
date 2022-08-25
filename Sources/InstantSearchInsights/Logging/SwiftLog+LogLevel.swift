//
//  SwiftLog+LogService.swift
//  
//
//  Created by Vladislav Fitc on 23/10/2020.
//

import Foundation
import AlgoliaSearchClient
import Logging

public typealias LogLevel = AlgoliaSearchClient.LogLevel

public extension LogLevel {

  init(swiftLogLevel: Logging.Logger.Level) {
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

  var swiftLogLevel: Logging.Logger.Level {
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

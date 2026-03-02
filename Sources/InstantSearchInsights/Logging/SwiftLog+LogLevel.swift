//
//  SwiftLog+LogService.swift
//
//
//  Created by Vladislav Fitc on 23/10/2020.
//

import Foundation
import Logging

public typealias LogLevel = Logging.Logger.Level

public extension LogLevel {
  init(swiftLogLevel: Logging.Logger.Level) {
    self = swiftLogLevel
  }

  var swiftLogLevel: Logging.Logger.Level {
    return self
  }
}

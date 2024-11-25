//
//  Logs.swift
//
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation

public struct Logs {
  public static let logLevelChangeNotficationName = Notification.Name("com.algolia.logLevelChange")

  public static var logSeverityLevel: LogLevel = .info {
    didSet {
      let notification = Notification(name: logLevelChangeNotficationName, object: nil, userInfo: ["logLevel": logSeverityLevel])
      NotificationCenter.default.post(notification)
    }
  }

  private init() {}
}

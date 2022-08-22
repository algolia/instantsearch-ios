//
//  Logs.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
import AlgoliaSearchClient

public struct Logs {

  public static var logSeverityLevel: LogLevel = .info {
    didSet {
      let notification = Notification(name: Notification.Name("com.algolia.logLevelChange"), object: nil, userInfo: ["logLevel": logSeverityLevel])
      NotificationCenter.default.post(notification)
    }
  }

  private init() {}

}

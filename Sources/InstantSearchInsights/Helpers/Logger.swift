//
//  Logger.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class Logger {
  var enabled = false
  let appId: String
  let outputHandler: (String) -> Void
  
  init(_ appId: String, _ output: @escaping (String) -> Void = dPrint) {
    self.appId = appId
    self.outputHandler = output
  }
  
  func debug(message: String) {
    if enabled {
      outputHandler("[Algolia Insights - \(appId)] \(message)")
    }
  }
}

func dPrint(_ message: String) {
  print(message)
}

//
//  Telemetry.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation

class Telemetry {
  
  static let shared = Telemetry()
  
  private var usage: Usage = .init()
  
  var value: Int {
    return usage.rawValue
  }
  
  func track(_ usage: Usage) {
    self.usage.insert(usage)
  }
  
  struct Usage: OptionSet {
    let rawValue: Int
    
    static let hitsSearcher = Usage(rawValue: 1 << 0)
    static let facetSearcher = Usage(rawValue: 1 << 1)
    static let filterState = Usage(rawValue: 1 << 2)
    
  }
  
}

extension Telemetry: UserAgentExtending {
  
  var userAgentExtension: String {
    return "Usage: \(value)"
  }
  
}

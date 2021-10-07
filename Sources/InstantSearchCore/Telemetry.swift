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
    static let highlightedString = Usage(rawValue: 1 << 3)
    static let searchConnector = Usage(rawValue: 1 << 4)
    
    static let currentFiltersInteractor = Usage(rawValue: 1 << 5)
    static let currentFiltersConnector = Usage(rawValue: 1 << 6)
    
    static let dynamicFacetsInteractor = Usage(rawValue: 1 << 7)
    static let dynamicFacetsConnector = Usage(rawValue: 1 << 8)
    
    static let facetListInteractor = Usage(rawValue: 1 << 9)
    static let facetListConnector = Usage(rawValue: 1 << 10)
    
    static let filterClearInteractor = Usage(rawValue: 1 << 11)
    static let filterClearConnector = Usage(rawValue: 1 << 12)
    
    static let filterListInteractor = Usage(rawValue: 1 << 13)
    static let filterListConnector = Usage(rawValue: 1 << 14)
    
    static let hierarchicalInteractor = Usage(rawValue: 1 << 15)
    static let hierarchicalConnector = Usage(rawValue: 1 << 16)
    
    static let hitsInteractor = Usage(rawValue: 1 << 17)
    static let hitsConnector = Usage(rawValue: 1 << 18)
    
    static let loadingInteractor = Usage(rawValue: 1 << 19)
    static let loadingConnector = Usage(rawValue: 1 << 20)
    
    static let numberInteractor = Usage(rawValue: 1 << 21)
    static let numberConnector = Usage(rawValue: 1 << 22)
    
    static let numberRangeInteractor = Usage(rawValue: 1 << 23)
    static let numberRangeConnector = Usage(rawValue: 1 << 24)
    
    static let queryInputInteractor = Usage(rawValue: 1 << 25)
    static let queryInputConnector = Usage(rawValue: 1 << 26)
    
    static let queryRuleCustomDataInteractor = Usage(rawValue: 1 << 27)
    static let queryRuleCustomDataConnector = Usage(rawValue: 1 << 28)
    
    static let relevantSortInteractor = Usage(rawValue: 1 << 29)
    static let relevantSortConnector = Usage(rawValue: 1 << 30)
    
    static let sortByInteractor = Usage(rawValue: 1 << 31)
    static let sortByConnector = Usage(rawValue: 1 << 32)
    
    static let statsInteractor = Usage(rawValue: 1 << 33)
    static let statsConnector = Usage(rawValue: 1 << 34)
    
    static let filterToggleInteractor = Usage(rawValue: 1 << 35)
    static let filterToggleConnector = Usage(rawValue: 1 << 36)
  }
  
}

extension Telemetry: UserAgentExtending {
  
  var userAgentExtension: String {
    return "Usage: \(value)"
  }
  
}

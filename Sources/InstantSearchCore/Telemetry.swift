//
//  Telemetry.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation

enum TrackableComponent: UInt8 {
  
  case hitsSearcher = 1
  case facetSearcher = 2
  case filterState = 3
  case highlightedString
  case searchConnector
  
  case currentFiltersInteractor
  case currentFiltersConnector
  
  case dynamicFacetsInteractor
  case dynamicFacetsConnector
  
  case facetListInteractor
  case facetListConnector
  
  case filterClearInteractor
  case filterClearConnector
  
  case filterListInteractor
  case filterListConnector
  
  case hierarchicalInteractor
  case hierarchicalConnector
  
  case hitsInteractor
  case hitsConnector
  
  case loadingInteractor
  case loadingConnector
  
  case numberInteractor
  case numberConnector
  
  case numberRangeInteractor
  case numberRangeConnector
  
  case queryInputInteractor
  case queryInputConnector
  
  case queryRuleCustomDataInteractor
  case queryRuleCustomDataConnector
  
  case relevantSortInteractor
  case relevantSortConnector
  
  case sortByInteractor
  case sortByConnector
  
  case statsInteractor
  case statsConnector
  
  case filterToggleInteractor
  case filterToggleConnector
  
  var description: String {
    switch self {
    case .hitsSearcher:
      return "hitsSearcher"
    default:
      return ""
    }
  }
  
  func parameters(rawValue: UInt64) -> Set<String> {
    switch self {
    case .hitsSearcher:
      return SingleIndexSearcher.TelemetryParameters(rawValue: rawValue).parameters
    default:
      return []
    }
  }
  
}

protocol TelemetryTrackable {
  
  associatedtype TelemetryParameters: OptionSet = NoParameters where TelemetryParameters.RawValue == UInt64
  
  var telemetryID: UInt8 { get }
  
  
}

struct NoParameters: OptionSet {
  
  let rawValue: UInt64
  
}

extension TelemetryTrackable {
  
  func track(with parameters: TelemetryParameters...) {
    Telemetry.shared.track(component: self, parameters: parameters)
  }
  
  func track() {
    Telemetry.shared.track(component: self, parameters: [])
  }
  
}

class Telemetry {
  
  static let shared = Telemetry()
  
  private var usage: [UInt8: UInt64] = [:]
    
  var value: String {
    return usage.sorted(by: \.key).map { String(UInt64($0) << 56 | $1) }.joined(separator: ",")
  }
  
  func track<T: TelemetryTrackable>(component: T, parameters: [T.TelemetryParameters]) {
    usage[component.telemetryID] = parameters.map(\.rawValue).reduce(0, { $0 | 1 << $1 })
  }
  
}

class TelemetryParser {
  
  let componentOffset = 56
  let componentMask: UInt64 = 0xFF00000000000000
  let parametersMask: UInt64 = 0x00FFFFFFFFFFFFFF
  
  func parse(rawString: String) -> [String: Set<String>] {
    var output: [String: Set<String>] = [:]
    rawString.split(separator: ",").compactMap { UInt64($0) }.forEach { rawIntComponent in
      TrackableComponent(rawValue: UInt8((rawIntComponent & componentMask) >> componentOffset)).flatMap {
        output[$0.description] = $0.parameters(rawValue: rawIntComponent & parametersMask)
      }
    }
    return output
  }
  
}

extension Telemetry: UserAgentExtending {
  
  var userAgentExtension: String {
    return "ISusage(\(value))"
  }
  
}



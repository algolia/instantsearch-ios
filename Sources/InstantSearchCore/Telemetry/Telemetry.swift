//
//  Telemetry.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation


class Telemetry {
  
  static let shared = Telemetry()
  
  var schema = TelemetrySchema()
  
  var components: [TelemetryComponentType: TelemetryComponent] = [:]
    
  var value: String {
    return try! schema.serializedData().base64EncodedString()
  }
  
  func trackConnector(type: TelemetryComponentType,
                      parameters: TelemetryComponentParams...) {
    trackConnector(type: type,
                   parameters: parameters)
  }
  
  func trackConnector(type: TelemetryComponentType,
                      parameters: [TelemetryComponentParams?]) {
    trackConnector(type: type,
                   parameters: parameters.compactMap { $0 })
  }
  
  func trackConnector(type: TelemetryComponentType,
                      parameters: [TelemetryComponentParams]) {
    let widget = TelemetryComponent.with {
      $0.type = type
      $0.parameters = parameters
      $0.isConnector = true
    }
    components[type] = widget
  }
  
  func track(type: TelemetryComponentType,
             parameters: TelemetryComponentParams...) {
    track(type: type,
          parameters: parameters)
  }
  
  func track(type: TelemetryComponentType,
             parameters: [TelemetryComponentParams?]) {
    track(type: type,
          parameters: parameters.compactMap { $0 })
  }

  
  func track(type: TelemetryComponentType,
             parameters: [TelemetryComponentParams]) {
    let widget = TelemetryComponent.with {
      $0.type = type
      $0.parameters = parameters
      $0.isConnector = false
    }
    if components[type]?.isConnector != true {
      components[type] = widget
    }
  }
  
}

extension TelemetryComponentParams {
  
  static let filterState = TelemetryComponentParams.filterStateParameter
  
}

extension Telemetry: UserAgentExtending {
  
  var userAgentExtension: String {
    return "telemetry: \(value)"
  }
  
}



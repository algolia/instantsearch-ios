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
    
  var value: String {
    return try! schema.serializedData().base64EncodedString()
  }
  
  func track(type: TelemetryComponentType, parameters: [TelemetryComponentParams], useConnector: Bool) {
    let widget = TelemetryComponent.with {
      $0.type = type
      $0.parameters = parameters
      $0.isConnector = useConnector
    }
    if let widgetIndex = schema.components.firstIndex(where: { $0.type == type }) {
      schema.components[widgetIndex] = widget
    } else {
      schema.components.append(widget)
    }
  }
  
}

extension Telemetry: UserAgentExtending {
  
  var userAgentExtension: String {
    return "telemetry: \(value)"
  }
  
}



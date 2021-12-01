//
//  Telemetry.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation
import Gzip

class Telemetry {
  
  /// Shared telemetry tracking instance
  static let shared = Telemetry()
  
  /// Is telemetry tracking on
  var isOn: Bool = true
    
  /// Dictionary mapping a component to its type, ensuring each component is tracked only once
  var components: [TelemetryComponentType: TelemetryComponent] = [:] {
    didSet {
      if oldValue != components {
        schema = .with {
          $0.components = Array(components.values).sorted(by: \.type.rawValue)
        }
      }
    }
  }
  
  /// Telemetry protobuf schema
  /// - Note: Updated after each update of the `components` dictionary
  private var schema: TelemetrySchema = .init()
    
  /// gzipped base64 encoded telemetry string value
  var encodedValue: String? {
    guard isOn else {
      return nil
    }
    guard let telemetryDataString = try? schema.serializedData().gzipped().base64EncodedString() else {
      return nil
    }
    return telemetryDataString
  }
  
  func traceConnector(type: TelemetryComponentType,
                      parameters: TelemetryComponentParams...) {
    traceConnector(type: type,
                   parameters: parameters)
  }
  
  func traceConnector(type: TelemetryComponentType,
                      parameters: [TelemetryComponentParams?]) {
    traceConnector(type: type,
                   parameters: parameters.compactMap { $0 })
  }
  
  func traceConnector(type: TelemetryComponentType,
                      parameters: [TelemetryComponentParams]) {
    trace(type: type,
          parameters: parameters,
          isConnector: true)
  }
  
  func trace(type: TelemetryComponentType,
             parameters: TelemetryComponentParams...) {
    trace(type: type,
          parameters: parameters)
  }
  
  func trace(type: TelemetryComponentType,
             parameters: [TelemetryComponentParams?]) {
    trace(type: type,
          parameters: parameters.compactMap { $0 })
  }

  
  func trace(type: TelemetryComponentType,
             parameters: [TelemetryComponentParams]) {
    trace(type: type,
          parameters: parameters,
          isConnector: false)
  }
  
  private func trace(type: TelemetryComponentType,
                     parameters: [TelemetryComponentParams],
                     isConnector: Bool) {
    guard isOn else { return }
    
    let isExistingComponentConnector: Bool
    let existingComponentParameters: [TelemetryComponentParams]
    
    if let existingComponent = components[type] {
      isExistingComponentConnector = existingComponent.isConnector
      existingComponentParameters = existingComponent.parameters
    } else {
      isExistingComponentConnector = false
      existingComponentParameters = []
    }
    
    let component = TelemetryComponent.with {
      $0.type = type
      $0.parameters = Array(Set(parameters).union(existingComponentParameters)).sorted(by: \.rawValue)
      $0.isConnector = isExistingComponentConnector || isConnector
    }
    
    components[type] = component
  }
  
}

extension TelemetryComponentParams {
  
  static let filterState = TelemetryComponentParams.filterStateParameter
  static let hitsSearcher = TelemetryComponentParams.hitsSearcherParameter
  static let facetSearcher = TelemetryComponentParams.facetSearcherParameter
  
}

extension Telemetry: UserAgentExtending {
  
  var userAgentExtension: String {
    return encodedValue.flatMap { "InstantSearchTelemetry(\($0))" } ?? ""
  }
  
}



//
//  Telemetry.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation
import InstantSearchTelemetry

typealias Telemetry = InstantSearchTelemetry

extension Telemetry: UserAgentExtending {

  public var userAgentExtension: String {
    return encodedValue.flatMap { "ISTelemetry(\($0))" } ?? ""
  }

}

//
//  AppTaskID.swift
//  
//
//  Created by Vladislav Fitc on 01/02/2021.
//

import Foundation

// Identifier of an app-level task
public struct AppTaskID: StringWrapper {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

}

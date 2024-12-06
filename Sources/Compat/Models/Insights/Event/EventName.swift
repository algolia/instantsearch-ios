//
//  EventName.swift
//
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

public struct EventName: StringWrapper {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

}

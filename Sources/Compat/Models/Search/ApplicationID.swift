//
//  ApplicationID.swift
//
//
//  Created by Vladislav Fitc on 19/02/2020.
//

import Foundation

public struct ApplicationID: StringWrapper, Hashable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }

  public static func == (lhs: ApplicationID, rhs: ApplicationID) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}

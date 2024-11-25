//
//  QueryID.swift
//
//
//  Created by Vladislav Fitc on 19/03/2020.
//

import Foundation

public struct QueryID: StringWrapper {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

}

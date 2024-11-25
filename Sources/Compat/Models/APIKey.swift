//
//  APIKey.swift
//
//
//  Created by Vladislav Fitc on 20/02/2020.
//

import Foundation

public struct APIKey: StringWrapper {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

}

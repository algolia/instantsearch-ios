//
//  Attribute.swift
//
//
//  Created by Vladislav Fitc on 02/03/2020.
//

import Foundation

public struct Attribute: StringWrapper, URLEncodable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

}

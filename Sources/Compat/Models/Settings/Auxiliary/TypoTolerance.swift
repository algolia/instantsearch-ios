//
//  TypoTolerance.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public enum TypoTolerance: String, Codable, URLEncodable {
  case `true`
  case `false`
  case min
  case strict
}

extension TypoTolerance: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: Bool) {
    self = value ? .true : .false
  }

}

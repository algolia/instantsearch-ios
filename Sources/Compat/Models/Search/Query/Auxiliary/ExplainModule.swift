//
//  ExplainModule.swift
//  
//
//  Created by Vladislav Fitc on 23/03/2020.
//

import Foundation

public struct ExplainModule: StringOption, ProvidingCustomOption, URLEncodable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  public static var matchAlternatives: Self { .init(rawValue: "match.alternatives") }

}

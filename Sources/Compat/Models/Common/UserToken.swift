//
//  UserToken.swift
//
//
//  Created by Vladislav Fitc on 20/03/2020.
//

import Foundation

public struct UserToken: StringWrapper, URLEncodable {

  public let rawValue: String

  private let allowedCharacters: CharacterSet = CharacterSet.alphanumerics.union(.init(charactersIn: "._-"))

  public init(rawValue: String) {
    assert(!rawValue.isEmpty, "UserToken can't be empty")
    assert(rawValue.count <= 64, "UserToken length can't be superior to 64 characters. Input: \(rawValue)")
    let containsOnlyAllowedCharacters = rawValue.trimmingCharacters(in: allowedCharacters).isEmpty
    assert(containsOnlyAllowedCharacters, "UserToken allows only characters of type [a-zA-Z0-9_-.]. Input: \(rawValue)")
    self.rawValue = rawValue
  }

}

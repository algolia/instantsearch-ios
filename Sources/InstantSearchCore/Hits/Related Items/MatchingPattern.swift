//
//  MatchingPattern.swift
//  InstantSearchCore
//
//  Created by test test on 23/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public struct MatchingPattern<Model> {
  let attribute: String
  let score: Int
  let oneOrManyElementsInKeyPath: OneOrManyElementsInKeyPath<Model, String>

  public init(attribute: String, score: Int, filterPath: KeyPath<Model, String>) {
    self.attribute = attribute
    self.score = score
    oneOrManyElementsInKeyPath = .one(filterPath)
  }

  public init(attribute: String, score: Int, filterPath: KeyPath<Model, [String]>) {
    self.attribute = attribute
    self.score = score
    oneOrManyElementsInKeyPath = .many(filterPath)
  }

  enum OneOrManyElementsInKeyPath<T, V> {
    case one(KeyPath<T, V>)
    case many(KeyPath<T, [V]>)
  }
}

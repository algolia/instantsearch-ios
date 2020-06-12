//
//  MatchingPattern.swift
//  InstantSearchCore
//
//  Created by test test on 23/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public struct MatchingPattern<Model> {
  let attribute: Attribute
  let score: Int
  let oneOrManyElementsInKeyPath: OneOrManyElementsInKeyPath<Model, String>

  public init(attribute: Attribute, score: Int, filterPath: KeyPath<Model, String>) {
    self.attribute = attribute
    self.score = score
    self.oneOrManyElementsInKeyPath = .one(filterPath)
  }

  public init(attribute: Attribute, score: Int, filterPath: KeyPath<Model, [String]>) {
    self.attribute = attribute
    self.score = score
    self.oneOrManyElementsInKeyPath = .many(filterPath)
  }

  enum OneOrManyElementsInKeyPath<T, V> {
    case one(KeyPath<T, V>)
    case many(KeyPath<T, [V]>)
  }
}

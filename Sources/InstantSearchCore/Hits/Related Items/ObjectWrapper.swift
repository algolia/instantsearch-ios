//
//  ObjectWrapper.swift
//  InstantSearchCore
//

import Foundation

/// Wraps an object with its Algolia objectID for related-items matching.
public struct ObjectWrapper<Object> {
  public let objectID: String
  public let object: Object

  public init(object: Object, objectID: String) {
    self.object = object
    self.objectID = objectID
  }
}

public extension ObjectWrapper where Object: Indexable {
  init(object: Object) {
    self.object = object
    self.objectID = object.objectID
  }
}


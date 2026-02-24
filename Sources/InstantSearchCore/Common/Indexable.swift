//
//  Indexable.swift
//  InstantSearchCore
//

import Foundation

/// Protocol describing objects that can be indexed in Algolia.
public protocol Indexable {
  var objectID: String { get }
}


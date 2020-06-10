//
//  HiearchicalInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 03/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias HierarchicalPath = [Filter.Facet]

public class HierarchicalInteractor: ItemInteractor<[[Facet]]> {

  let hierarchicalAttributes: [Attribute]
  let separator: String

  // Might be a string?
  public var selections: [String] {
    didSet {
      if oldValue != selections {
        onSelectionsChanged.fire(selections)
      }
    }
  }

  public let onSelectionsChanged: Observer<[String]>
  public let onSelectionsComputed: Observer<HierarchicalPath>

  public init(hierarchicalAttributes: [Attribute], separator: String) {
    self.hierarchicalAttributes = hierarchicalAttributes
    self.separator = separator
    self.onSelectionsChanged = .init()
    self.onSelectionsComputed = .init()
    self.selections = []
    super.init(item: [])

  }

  public func computeSelection(key: String) {
    let selections = key.subPaths(withSeparator: separator)
    let hierarchicalPath = zip(hierarchicalAttributes, selections).map { Filter.Facet(attribute: $0, stringValue: $1) }
    onSelectionsComputed.fire(hierarchicalPath)
  }
}

public enum Hierarchical {}

extension String {

  func subPaths(withSeparator separator: String) -> [String] {
    return components(separatedBy: separator).reduce([]) { (paths, component) in
      let newPath = paths.last.flatMap { $0 + separator + component } ?? component
      return paths + [newPath]
    }
  }

}

//
//  HiearchicalInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 03/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias HierarchicalPath = [Filter.Facet]

/// Component containing the business logic of the hierarchical menu
public class HierarchicalInteractor: ItemInteractor<[[Facet]]> {

  /// The names of the hierarchical attributes that we need to target, in ascending order.
  let hierarchicalAttributes: [Attribute]

  /// The string separating the facets in the hierarchical facets. Usually something like " > ".
  ///
  /// Note that you should not forget the spaces in between if there are some in your separator.
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

  /**
   - Parameters:
     - hierarchicalAttributes: The names of the hierarchical attributes that we need to target, in ascending order.
     - separator: The string separating the facets in the hierarchical facets. Usually something like " > ".
  */
  public init(hierarchicalAttributes: [Attribute], separator: String) {
    self.hierarchicalAttributes = hierarchicalAttributes
    self.separator = separator
    self.onSelectionsChanged = .init()
    self.onSelectionsComputed = .init()
    self.selections = []
    super.init(item: [])
    Telemetry.shared.trace(type: .hierarchicalFacets)
  }

  public func computeSelection(key: String) {
    let selections = key.subpaths(withSeparator: separator)
    var hierarchicalPath = zip(hierarchicalAttributes, selections).map { Filter.Facet(attribute: $0, stringValue: $1) }
    if self.selections == selections {
      hierarchicalPath.removeLast()
    }
    onSelectionsComputed.fire(hierarchicalPath)
  }
}

public enum Hierarchical {}

extension String {

  /** Build a list of all subpaths for a path with a provided separator
      Example:
        - input: Clothing > Women > Bags
        - output: ["Clothing", "Clothing > Women". "Clothing > Women > Bags"]
  */
  func subpaths(withSeparator separator: String) -> [String] {
    return components(separatedBy: separator).reduce([]) { (paths, component) in
      let newPath = paths.last.flatMap { $0 + separator + component } ?? component
      return paths + [newPath]
    }
  }

}

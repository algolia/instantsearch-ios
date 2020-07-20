//
//  HierarchicalPresenter.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias HierarchicalPresenter = ([HierarchicalFacet]) -> [HierarchicalFacet]

public extension DefaultPresenter {

  enum Hierarchical {

    public static let present: HierarchicalPresenter = { facets in
      let levels = Set(facets.map { $0.level }).sorted()

      guard !levels.isEmpty else { return facets }

      var output: [HierarchicalFacet] = []

      output.reserveCapacity(facets.count)

      levels.forEach { level in
        let facetsForLevel = facets
          .filter { $0.level == level }
          .sorted { $0.facet.value < $1.facet.value }
        let indexToInsert = output
          .lastIndex { $0.isSelected }
          .flatMap { output.index(after: $0) } ?? output.endIndex
        output.insert(contentsOf: facetsForLevel, at: indexToInsert)
      }

      return output
    }

  }
}

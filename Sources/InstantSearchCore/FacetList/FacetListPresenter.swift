//
//  FacetListPresenter.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 18/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias SelectableItem<T> = (item: T, isSelected: Bool)

public protocol SelectableListPresentable {

  func transform(refinementFacets: [SelectableItem<Facet>]) -> [SelectableItem<Facet>]
}

/// Takes care of building the content of a refinement list given the following:
/// - The list of Facets + Associated Count
/// - The list of Facets that have been refined
/// - Layout settings such as sortBy
public class FacetListPresenter: SelectableListPresentable {

  let sortBy: [FacetSortCriterion]
  let limit: Int
  let showEmptyFacets: Bool

  public init(sortBy: [FacetSortCriterion] = [.count(order: .descending)],
              limit: Int = .max,
              showEmptyFacets: Bool = true) {
    self.sortBy = sortBy
    self.limit = limit
    self.showEmptyFacets = showEmptyFacets
  }

  /// Builds the final list to be displayed in the refinement list
  public func transform(refinementFacets: [SelectableItem<Facet>]) -> [SelectableItem<Facet>] {
    let filteredOutput = refinementFacets.filter { showEmptyFacets ? true : !$0.item.isEmpty }
    let sortedOutput = filteredOutput.sorted(by: sorter(using: sortBy))
    let upperBoundIndex = min(limit, sortedOutput.count)
    let boundedOutput = sortedOutput[..<upperBoundIndex]
    return Array(boundedOutput)
  }

  private func sorter(using sortCriterions: [FacetSortCriterion]) -> (SelectableItem<Facet>, SelectableItem<Facet>) -> (Bool) {
    return { (lhs, rhs) in

      let lhsChecked: Bool = lhs.isSelected
      let rhsChecked: Bool = rhs.isSelected

      let leftCount = lhs.item.count
      let rightCount = rhs.item.count
      let leftValueLowercased = lhs.item.value.lowercased()
      let rightValueLowercased = rhs.item.value.lowercased()

      // tiebreaking algorithm to do determine the sorting.
      for sortCriterion in sortCriterions {

        switch sortCriterion {
        case .isRefined where lhsChecked != rhsChecked:
          return lhsChecked

        case .count(order: .descending) where leftCount != rightCount:
          return leftCount > rightCount

        case .count(order: .ascending) where leftCount != rightCount:
          return leftCount < rightCount

        case .alphabetical(order: .descending) where leftValueLowercased != rightValueLowercased:
          return leftValueLowercased > rightValueLowercased

        // Sort by Name ascending. Else, Biggest Count wins by default
        case .alphabetical(order: .ascending) where leftValueLowercased != rightValueLowercased:
          return leftValueLowercased < rightValueLowercased

        default:
          break
        }

      }

      return leftValueLowercased < rightValueLowercased

    }
  }

}

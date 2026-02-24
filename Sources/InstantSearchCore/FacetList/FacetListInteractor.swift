//
//  RefinementFacetInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FacetListInteractor: SelectableListInteractor<String, FacetHits> {
  public let onResultsUpdated: Observer<SearchForFacetValuesResponse>
  private let mutationQueue: OperationQueue

  public init(facets: [FacetHits] = [], selectionMode: SelectionMode = .multiple) {
    onResultsUpdated = .init()
    mutationQueue = .init()
    super.init(items: facets, selectionMode: selectionMode)
    mutationQueue.maxConcurrentOperationCount = 1
    mutationQueue.qualityOfService = .userInitiated
    Telemetry.shared.trace(type: .facetList,
                           parameters: [
                             facets.isEmpty ? .none : .facets,
                             selectionMode == .multiple ? .none : .selectionMode
                           ].compactMap { $0 })
  }
}

extension FacetListInteractor: ResultUpdatable {
  @discardableResult public func update(_ facetResults: SearchForFacetValuesResponse) -> Operation {
    let updateOperation = BlockOperation { [weak self] in
      self?.items = facetResults.facetHits.map { hit in
        FacetHits(value: hit.value, highlighted: hit.highlighted, count: hit.count)
      }
      self?.onResultsUpdated.fire(facetResults)
    }

    mutationQueue.addOperation(updateOperation)

    return updateOperation
  }
}

public enum FacetSortCriterion {
  case count(order: Order)
  case alphabetical(order: Order)
  case isRefined

  public enum Order {
    case ascending
    case descending
  }
}

public enum RefinementOperator {
  // when operator is 'and' + one single value can be selected,
  // we want to keep the other values visible, so we have to do a disjunctive facet
  // In the case of multi value that can be selected in conjunctive case,
  // then we avoid doing a disjunctive facet and just do normal conjusctive facet
  // and only the remaining possible facets will appear.
  case and
  case or
}

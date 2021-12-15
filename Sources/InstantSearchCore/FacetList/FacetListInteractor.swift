//
//  RefinementFacetInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

public class FacetListInteractor: SelectableListInteractor<String, Facet> {

  public let onResultsUpdated: Observer<FacetSearchResponse>
  private let mutationQueue: OperationQueue

  public init(facets: [Facet] = [], selectionMode: SelectionMode = .multiple) {
    self.onResultsUpdated = .init()
    self.mutationQueue = .init()
    super.init(items: facets, selectionMode: selectionMode)
    self.mutationQueue.maxConcurrentOperationCount = 1
    self.mutationQueue.qualityOfService = .userInitiated
    Telemetry.shared.trace(type: .facetList,
                           parameters: [
                            facets.isEmpty ? .none : .facets,
                            selectionMode == .multiple ? .none : .selectionMode
                           ].compactMap { $0 })
  }

}

extension FacetListInteractor: ResultUpdatable {

  @discardableResult public func update(_ facetResults: FacetSearchResponse) -> Operation {

    let updateOperation = BlockOperation { [weak self] in
      self?.items = facetResults.facetHits
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

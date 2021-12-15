//
//  RelevantSortInteractor.swift
//  
//
//  Created by Vladislav Fitc on 04/02/2021.
//

import Foundation

/**
 Component storing the relevant sort priority applied to the search in the dynamically sorted index (virtual replica) and providing the interface to toggle this value.
 
 - Usage of the virtual index replica introduces a trade-off between the number of results and the relevancy of results.
   `RelevantSort` components provide the convenient interface to switch between these parameters.
 - `.none` value represents the undefined state, meaning that either the interactor is not connected to a searcher or the searched index is not a virtual replica.
 */
public class RelevantSortInteractor: ItemInteractor<RelevantSortPriority?> {

  public init(priority: RelevantSortPriority? = nil) {
    super.init(item: priority)
    self.onItemChanged.fire(priority)
    Telemetry.shared.trace(type: .relevantSort,
                           parameters: [
                            priority == nil ? .none : .priority
                           ])
  }

  /// Switch the relevant sort priority to the opposite one
  /// Skipped if the current value of sort priority is nil
  public func toggle() {
    switch item {
    case .some(.hitsCount):
      item = .relevancy
    case .some(.relevancy):
      item = .hitsCount
    default:
      break
    }
  }

}

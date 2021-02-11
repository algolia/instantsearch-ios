//
//  DynamicSortToggleInteractor.swift
//  
//
//  Created by Vladislav Fitc on 04/02/2021.
//

import Foundation

/**
 Component that stores the currently applied dynamic sort priority applied to the search in the dynamically sorted index (virtual replica) and provides the interface to toggle this value.
 
 - Usage of the dynamically sorted index introduces the tradeoff between the number of results
 and the relevancy of results. DynamicSortToggle components provide the convenient interface to switch between these options.
 - .none value represents the undefined state, meaning that either the interactor has never been connected to a searcher, or the searched index is not the virtual replica.
 */
public class DynamicSortToggleInteractor: ItemInteractor<DynamicSortPriority?> {
  
  public init(priority: DynamicSortPriority? = nil) {
    super.init(item: priority)
    self.onItemChanged.fire(priority)
  }
  
  /// Switch the dynamic sort priority to the opposite one
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

//
//  ClearRefinementsController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

import Foundation
import InstantSearchCore

public protocol ClearRefinementsController: class {
  
  var clearRefinements: (() -> Void)? { get set }
  
}

public extension ClearRefinementsController {
  
  func connectFilterState(_ filterState: FilterState) {
    clearRefinements = { [weak filterState] in filterState?.notify(.removeAll) }
  }
  
}

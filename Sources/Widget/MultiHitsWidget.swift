//
//  MultiHitsWidget.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/04/2019.
//

import Foundation
import InstantSearchCore

public protocol MultiHitsWidget: class {
  
  var hitsSource: MultiHitsSource? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

public protocol MultiHitsSource: class {
  
  func numberOfSections() -> Int
  func numberOfHits(inSection section: Int) -> Int
  func hit<R: Codable>(atIndex index: Int, inSection section: Int) throws -> R?
  
}

extension MultiHitsViewModel: MultiHitsSource {}

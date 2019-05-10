//
//  MultiHitsSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 10/05/2019.
//

import Foundation
import InstantSearchCore

public protocol MultiHitsSource: class {
  
  func numberOfSections() -> Int
  func numberOfHits(inSection section: Int) -> Int
  func hit<R: Codable>(atIndex index: Int, inSection section: Int) throws -> R?
  
}

extension MultiHitsViewModel: MultiHitsSource {}

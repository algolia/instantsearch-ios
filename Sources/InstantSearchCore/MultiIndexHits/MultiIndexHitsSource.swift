//
//  MultiIndexHitsSource.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
public protocol MultiIndexHitsSource: AnyObject {
  func numberOfSections() -> Int
  func numberOfHits(inSection section: Int) -> Int
  func hit<R: Codable>(atIndex index: Int, inSection section: Int) throws -> R?
}

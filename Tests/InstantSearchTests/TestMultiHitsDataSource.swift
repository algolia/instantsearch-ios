//
//  TestMultiHitsDataSource.swift
//  InstantSearchTests
//
//  Created by Vladislav Fitc on 04/09/2019.
//

@testable import InstantSearch
import InstantSearchCore

class TestMultiHitsDataSource: MultiIndexHitsSource {
  
  let hitsBySection: [[String]]
  
  init(hitsBySection: [[String]]) {
    self.hitsBySection = hitsBySection
  }
  
  func numberOfSections() -> Int {
    return hitsBySection.count
  }
  
  func numberOfHits(inSection section: Int) -> Int {
    return hitsBySection[section].count
  }
  
  func hit<R: Codable>(atIndex index: Int, inSection section: Int) throws -> R? {
    return hitsBySection[section][index] as? R
  }
  
}

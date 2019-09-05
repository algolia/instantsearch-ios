//
//  TestHitsSource.swift
//  InstantSearchTests
//
//  Created by Vladislav Fitc on 04/09/2019.
//

@testable import InstantSearch
import Foundation

class TestHitsSource: HitsSource {
  
  typealias Hit = String
  
  let hits: [String]
  
  init(hits: [String]) {
    self.hits = hits
  }
  
  func numberOfHits() -> Int {
    return hits.count
  }
  
  func hit(atIndex index: Int) -> String? {
    guard index < hits.count else { return nil }
    return hits[index]
  }
  
}

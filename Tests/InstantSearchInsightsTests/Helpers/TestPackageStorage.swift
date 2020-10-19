//
//  TestPackageStorage.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
@testable import InstantSearchInsights

class TestPackageStorage<Item: Codable>: Storage {
  
  var storage: [Package<Item>] = []
  
  func store(_ packages: [Package<Item>]) {
    self.storage = packages
  }
  
  func load() -> [Package<Item>] {
    return storage
  }
  
}

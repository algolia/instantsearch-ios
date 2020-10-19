//
//  JSONFilePackageStorageTests.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
import XCTest
@testable import InstantSearchInsights

class JSONFilePackageStorageTests: XCTestCase {
  
  let filename: String = "testFile"
  
  override func tearDownWithError() throws {
    let storage = try JSONFilePackageStorage<[Package<String>]>(filename: filename)
    try FileManager.default.removeItem(at: storage.fileURL)
  }
  
  func testStoreLoad() throws {
    let storage = try JSONFilePackageStorage<[Package<String>]>(filename: filename)
    let packages: [Package<String>] = [try .init(items: ["1", "2"], capacity: 2), try .init(items: ["3", "4"], capacity: 2)]
    try storage.store(packages)
    let loadedPackages = try storage.load()
    XCTAssertEqual(loadedPackages.map(\.items), [["1", "2"], ["3", "4"]])
  }
    
}

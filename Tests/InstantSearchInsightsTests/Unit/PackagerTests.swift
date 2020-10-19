//
//  PackagerTests.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation

import XCTest
@testable import InstantSearchInsights

class PackagerTests: XCTestCase {
    
  func testInit() {
    
    let packager = Packager<String>(packages: [.init(item: "", capacity: 1)], packageCapacity: 2)
    
    XCTAssertEqual(packager.packageCapacity, 2)
    XCTAssertEqual(packager.packages.count, 1)
    XCTAssertEqual(packager.packages.first?.capacity, 1)
    XCTAssertEqual(packager.packages.first?.items.first, "")
  }
  
  func testSet() {
    var packager = Packager<String>(packages: [.init(item: "", capacity: 1)], packageCapacity: 2)
    
    let packages: [Package<String>] = [.init(item: "1", capacity: 1), .init(item: "2", capacity: 2)]
    
    packager.set(packages)
    
    XCTAssertEqual(packager.packages, packages)
  }
  
  func testPackToLastPackage() {
    
    var packager = Packager<String>(packages: [.init(item: "1", capacity: 2)], packageCapacity: 2)
    
    packager.pack("2")
    
    XCTAssertEqual(packager.packages.count, 1)
    XCTAssertEqual(packager.packages.first?.capacity, 2)
    XCTAssertEqual(packager.packages.first?.items, ["1", "2"])
    
    packager.pack("3")
    
    XCTAssertEqual(packager.packages.count, 2)
    XCTAssertEqual(packager.packages.first?.capacity, 2)
    XCTAssertEqual(packager.packages.first?.items, ["1", "2"])
    XCTAssertEqual(packager.packages.last?.capacity, 2)
    XCTAssertEqual(packager.packages.last?.items, ["3"])

  }
  
  func testRemove() throws {
    
    let packages: [Package<String>] = [
      try .init(items: ["1", "2"], capacity: 2),
      try .init(items: ["3"], capacity: 2)
    ]
    
    var packager = Packager<String>(packages: packages, packageCapacity: 2)

    packager.remove(packages.first!)
    
    XCTAssertEqual(packager.packages.count, 1)
    XCTAssertEqual(packager.packages.first?.capacity, 2)
    XCTAssertEqual(packager.packages.first?.items, ["3"])

    
  }
    

}

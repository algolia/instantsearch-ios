//
//  SmartSortInteractorTests.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SmartSortInteractorTests: XCTestCase {
  
  func testToggle() {
    let interactor = SmartSortInteractor()
    XCTAssertNil(interactor.item)
    interactor.toggle()
    XCTAssertNil(interactor.item)
    interactor.item = .hitsCount
    interactor.toggle()
    XCTAssertEqual(interactor.item, .relevancy)
    interactor.toggle()
    XCTAssertEqual(interactor.item, .hitsCount)
  }
  
}

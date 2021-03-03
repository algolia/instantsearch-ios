//
//  RelevantSortControllerConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class RelevantSortControllerConnectionTests: XCTestCase {
  
  class TestRelevantSortController: RelevantSortController {
    
    var didToggle: (() -> Void)?
    var item: RelevantSortPriority?
        
    func setItem(_ item: RelevantSortPriority?) {
      self.item = item
    }
    
  }

  weak var disposableController: TestRelevantSortController?
  weak var disposableInteractor: RelevantSortInteractor?

  func testLeak() {
    let interactor = RelevantSortInteractor()
    let controller = TestRelevantSortController()
    
    disposableInteractor = interactor
    disposableController = controller
    
    let connection = RelevantSortInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableController, "Leaked controller")
  }
  
  func testConnect() {
    let controller = TestRelevantSortController()
    let interactor = RelevantSortInteractor(priority: .relevancy)

    let connection = RelevantSortInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .hitsCount)
    
    interactor.item = .relevancy
    XCTAssertEqual(controller.item, .relevancy)
    
  }
  
  func testConnectMethod() {
    let controller = TestRelevantSortController()
    let interactor = RelevantSortInteractor(priority: .relevancy)

    interactor.connectController(controller) { $0 }
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .hitsCount)
    
    interactor.item = .relevancy
    XCTAssertEqual(controller.item, .relevancy)

  }
  
  func testDisconnect() {
    let controller = TestRelevantSortController()
    let interactor = RelevantSortInteractor(priority: .relevancy)

    let connection = RelevantSortInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
    connection.disconnect()
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .relevancy)
    
    interactor.item = .hitsCount
    XCTAssertEqual(controller.item, .relevancy)
  }
  
}

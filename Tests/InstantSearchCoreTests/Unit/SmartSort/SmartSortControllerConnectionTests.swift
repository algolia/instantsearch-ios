//
//  SmartSortControllerConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SmartSortControllerConnectionTests: XCTestCase {
  
  class TestSmartSortController: SmartSortController {
    
    var didToggle: (() -> Void)?
    var item: SmartSortPriority?
        
    func setItem(_ item: SmartSortPriority?) {
      self.item = item
    }
    
  }

  weak var disposableController: TestSmartSortController?
  weak var disposableInteractor: SmartSortInteractor?

  func testLeak() {
    let interactor = SmartSortInteractor()
    let controller = TestSmartSortController()
    
    disposableInteractor = interactor
    disposableController = controller
    
    let connection = SmartSortInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableController, "Leaked controller")
  }
  
  func testConnect() {
    let controller = TestSmartSortController()
    let interactor = SmartSortInteractor(priority: .relevancy)

    let connection = SmartSortInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .hitsCount)
    
    interactor.item = .relevancy
    XCTAssertEqual(controller.item, .relevancy)
    
  }
  
  func testConnectMethod() {
    let controller = TestSmartSortController()
    let interactor = SmartSortInteractor(priority: .relevancy)

    interactor.connectController(controller) { $0 }
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .hitsCount)
    
    interactor.item = .relevancy
    XCTAssertEqual(controller.item, .relevancy)

  }
  
  func testDisconnect() {
    let controller = TestSmartSortController()
    let interactor = SmartSortInteractor(priority: .relevancy)

    let connection = SmartSortInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
    connection.disconnect()
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .relevancy)
    
    interactor.item = .hitsCount
    XCTAssertEqual(controller.item, .relevancy)
  }
  
}

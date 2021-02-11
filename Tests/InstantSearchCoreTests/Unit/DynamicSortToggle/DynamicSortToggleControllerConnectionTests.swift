//
//  DynamicSortToggleControllerTests.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class DynamicSortToggleControllerConnectionTests: XCTestCase {
  
  class TestDynamicSortToggleController: DynamicSortToggleController {
    
    var didToggle: (() -> Void)?
    var item: DynamicSortPriority?
        
    func setItem(_ item: DynamicSortPriority?) {
      self.item = item
    }
    
  }

  weak var disposableController: TestDynamicSortToggleController?
  weak var disposableInteractor: DynamicSortToggleInteractor?

  func testLeak() {
    let interactor = DynamicSortToggleInteractor()
    let controller = TestDynamicSortToggleController()
    
    disposableInteractor = interactor
    disposableController = controller
    
    let connection = DynamicSortToggleInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableController, "Leaked controller")
  }
  
  func testConnect() {
    let controller = TestDynamicSortToggleController()
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)

    let connection = DynamicSortToggleInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .hitsCount)
    
    interactor.item = .relevancy
    XCTAssertEqual(controller.item, .relevancy)
    
  }
  
  func testConnectMethod() {
    let controller = TestDynamicSortToggleController()
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)

    interactor.connectController(controller) { $0 }
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .hitsCount)
    
    interactor.item = .relevancy
    XCTAssertEqual(controller.item, .relevancy)

  }
  
  func testDisconnect() {
    let controller = TestDynamicSortToggleController()
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)

    let connection = DynamicSortToggleInteractor.ControllerConnection(interactor: interactor, controller: controller) { $0 }
    connection.connect()
    connection.disconnect()
    
    XCTAssertEqual(controller.item, .relevancy)

    controller.didToggle?()
    XCTAssertEqual(interactor.item, .relevancy)
    
    interactor.item = .hitsCount
    XCTAssertEqual(controller.item, .relevancy)
  }
  
}

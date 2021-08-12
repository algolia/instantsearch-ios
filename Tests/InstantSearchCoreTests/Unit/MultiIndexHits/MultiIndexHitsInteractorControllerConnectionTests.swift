//
//  MultiIndexHitsInteractorControllerConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 07/08/2020.
//

import Foundation
import AlgoliaSearchClient
@testable import InstantSearchCore
import XCTest

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
class MultiIndexHitsInteractorControllerConnectionTests: XCTestCase {
  
  weak var disposableInteractor: MultiIndexHitsInteractor?
  weak var disposableController: TestMultiIndexHitsController?
  
  func testLeak() {
    let controller = TestMultiIndexHitsController()
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    disposableInteractor = interactor
    disposableController = controller
    
    let connection: Connection = MultiIndexHitsInteractor.ControllerConnection(interactor: interactor, controller: controller)
    connection.connect()

  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableController, "Leaked controller")
  }
  
  func testConnect() {
    
    let controller = TestMultiIndexHitsController()
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    let connection: Connection = MultiIndexHitsInteractor.ControllerConnection(interactor: interactor, controller: controller)
    connection.connect()
    
    ConnectionTester(controller: controller,
                     interactor: interactor,
                     source: self).check(isConnected: true)
    
  }
  
  func testConnectMethod() {
    
    let controller = TestMultiIndexHitsController()
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    interactor.connectController(controller)
    
    ConnectionTester(controller: controller,
                     interactor: interactor,
                     source: self).check(isConnected: true)
    
    
  }
  
  func testDisconnect() {
    let controller = TestMultiIndexHitsController()
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    let connection: Connection = MultiIndexHitsInteractor.ControllerConnection(interactor: interactor, controller: controller)
    connection.connect()
    connection.disconnect()
    
    ConnectionTester(controller: controller,
                     interactor: interactor,
                     source: self).check(isConnected: false)
    
  }
  
}

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
extension MultiIndexHitsInteractorControllerConnectionTests {
  
  class ConnectionTester {
    
    let controller: TestMultiIndexHitsController
    let interactor: MultiIndexHitsInteractor
    let source: XCTestCase
    
    init(controller: TestMultiIndexHitsController,
         interactor: MultiIndexHitsInteractor,
         source: XCTestCase) {
      self.controller = controller
      self.interactor = interactor
      self.source = source
    }
    
    func check(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      checkHitsSource(isConnected: isConnected, file: file, line: line)
      checkScrollToTop(isConnected: isConnected, file: file, line: line)
      checkReload(isConnected: isConnected, file: file, line: line)
      source.waitForExpectations(timeout: 3, handler: nil)
    }
    
    private func checkHitsSource(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      if isConnected {
        XCTAssert(controller.hitsSource === interactor, file: file, line: line)
      } else {
        XCTAssertNil(controller.hitsSource, file: file, line: line)
      }
    }
    
    private func checkScrollToTop(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      let expectation = source.expectation(description: "scroll to top")
      expectation.isInverted = !isConnected
      controller.didScrollToTop = {
        expectation.fulfill()
      }
      interactor.onRequestChanged.fire(())
    }
    
    private func checkReload(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      let expectation = source.expectation(description: "reload")
      expectation.isInverted = !isConnected
      controller.didReload = {
        expectation.fulfill()
      }
      interactor.onResultsUpdated.fire([])
    }
    
  }
  
}

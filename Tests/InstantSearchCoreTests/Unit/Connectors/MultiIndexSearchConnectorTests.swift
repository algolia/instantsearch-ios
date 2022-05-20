//
//  MultiIndexSearchConnectorTests.swift
//  
//
//  Created by Vladislav Fitc on 07/08/2020.
//

import Foundation
@testable import InstantSearchCore
import XCTest

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
class MultiIndexSearchConnectorTests: XCTestCase {
  
  struct ConnectorContainer {
    
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let indexModules: [MultiIndexHitsConnector.IndexModule] = [
      .init(indexName: "i1", hitsInteractor: HitsInteractor<JSON>()),
      .init(indexName: "i2", hitsInteractor: HitsInteractor<JSON>())
    ]
    let controller = TestMultiIndexHitsController()
    let queryInputInteractor = QueryInputInteractor()
    let queryInputController = TestSearchBoxController()
    
    lazy var connector = MultiIndexSearchConnector(searcher: searcher,
                                                   indexModules: indexModules,
                                                   hitsController: controller,
                                                   queryInputInteractor: queryInputInteractor,
                                                   queryInputController: queryInputController)
  }
  
  func testHitsInteractorSearcherConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = MultiIndexHitsInteractorSearcherConnectionTests.ConnectionTester(searcher: module.searcher,
                                                                                  interactor: module.connector.hitsConnector.interactor,
                                                                                  source: self)
    tester.check(isConnected: true)
  }
  
  func testHitsInteractorControllerConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = MultiIndexHitsInteractorControllerConnectionTests.ConnectionTester(controller: module.controller,
                                                                                    interactor: module.connector.hitsConnector.interactor,
                                                                                    source: self)
    tester.check(isConnected: true)
  }
  
  func testQueryInputSearcherConnect() {
    // to complete when SingleIndexSearcher become abstract enough
  }
  
  func testQueryInputControllerConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = SearchBoxControllerConnectionTester(interactor: module.queryInputInteractor,
                                                     controller: module.queryInputController,
                                                     presetQuery: nil,
                                                     source: self)
    tester.check(isConnected: true)
  }
  
  func testDisconnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    module.connector.disconnect()
    MultiIndexHitsInteractorSearcherConnectionTests.ConnectionTester(searcher: module.searcher,
                                                                     interactor: module.connector.hitsConnector.interactor,
                                                                     source: self).check(isConnected: false)
    MultiIndexHitsInteractorControllerConnectionTests.ConnectionTester(controller: module.controller,
                                                                       interactor: module.connector.hitsConnector.interactor,
                                                                       source: self).check(isConnected: false)
    SearchBoxControllerConnectionTester(interactor: module.queryInputInteractor,
                                        controller: module.queryInputController,
                                        presetQuery: nil,
                                        source: self).check(isConnected: false)
  }
  
}

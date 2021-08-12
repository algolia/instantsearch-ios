//
//  MultiIndexHitsInteractorSearcherConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 07/08/2020.
//

import Foundation
import AlgoliaSearchClient
@testable import InstantSearchCore
import XCTest

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
class MultiIndexHitsInteractorSearcherConnectionTests: XCTestCase {
  
  weak var disposableInteractor: MultiIndexHitsInteractor?
  weak var disposableSearcher: MultiIndexSearcher?
  
  func testLeak() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    disposableInteractor = interactor
    disposableSearcher = searcher
    
    let connection: Connection = MultiIndexHitsInteractor.SearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
  }
  
  override func tearDown() {
    
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableSearcher, "Leaked searcher")
  }
  
  func testConnect() {
    
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    let connection: Connection = MultiIndexHitsInteractor.SearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
    
    ConnectionTester(searcher: searcher,
                     interactor: interactor,
                     source: self).check(isConnected: true)
    
  }
  
  func testConnectMethod() {
    
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    interactor.connectSearcher(searcher)
    
    ConnectionTester(searcher: searcher,
                     interactor: interactor,
                     source: self).check(isConnected: true)
    
    
  }
  
  func testDisconnect() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let subInteractorA = HitsInteractor<JSON>()
    let subInteractorB = HitsInteractor<JSON>()
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [subInteractorA, subInteractorB])
    
    let connection: Connection = MultiIndexHitsInteractor.SearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
    connection.disconnect()
    
    ConnectionTester(searcher: searcher,
                     interactor: interactor,
                     source: self).check(isConnected: false)
    
  }
  
}

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
extension MultiIndexHitsInteractorSearcherConnectionTests {
  
  class ConnectionTester {
    
    let searcher: MultiIndexSearcher
    let interactor: MultiIndexHitsInteractor
    let source: XCTestCase
    
    init(searcher: MultiIndexSearcher,
         interactor: MultiIndexHitsInteractor,
         source: XCTestCase) {
      self.searcher = searcher
      self.interactor = interactor
      self.source = source
    }
    
    func check(isConnected: Bool,
               file: StaticString = #file,
               line: UInt = #line) {
      checkQueryChanged(isConnected: isConnected, file: file, line: line)
      checkResultsUpdated(isConnected: isConnected, file: file, line: line)
      source.waitForExpectations(timeout: 3, handler: nil)
    }
    
    private func checkQueryChanged(isConnected: Bool,
                                   file: StaticString = #file,
                                   line: UInt = #line) {
      let queryChangedExpectation = source.expectation(description: "query changed")
      queryChangedExpectation.isInverted = !isConnected
      
      interactor.onRequestChanged.subscribe(with: self) { _, _ in
        queryChangedExpectation.fulfill()
      }
      
      searcher.query = "query"
    }
    
    private func checkResultsUpdated(isConnected: Bool,
                                     file: StaticString = #file,
                                     line: UInt = #line) {
      let resultsUpdatedExpectation = source.expectation(description: "results updated")
      resultsUpdatedExpectation.isInverted = !isConnected
      
      interactor.onResultsUpdated.subscribe(with: self) { tester, _ in
        resultsUpdatedExpectation.fulfill()
      }
      
      let searchResponse = SearchesResponse(results: [
        SearchResponse(hits: [Hit(object: ["field0": "value0"])]),
        SearchResponse(hits: [Hit(object: ["field1": "value1"])]),
      ])
      
      searcher.onResults.fire(searchResponse)
    }
    
  }
  
}

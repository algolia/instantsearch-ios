//
//  TelemetryTests.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation
@testable import InstantSearchCore
import InstantSearchInsights
import XCTest


class TelemetryTests: XCTestCase {
  
  func testProtobuf() {
    let schema = Schema.with {
      $0.widgets = WidgetType.allCases.map { type in
        Widget.with { w in
          w.type = type
          w.useConnector = true
          w.params = [.appID, .apiKey, .indexName]
        }
      }// +
//      WidgetType.allCases.map { type in
//        Widget.with { w in
//          w.type = type
//          w.useConnector = false
//          w.params = [.appID, .apiKey, .indexName]
//        }
//      }
    }
    let data = try! schema.serializedData()
    print(data.base64EncodedString())
    print(data.count)

  }
  
//  func testMatchLevel() {
//    
//    XCTAssertEqual(Telemetry.shared.value, 0)
//    
//    _ = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
//    
//    XCTAssertEqual(Telemetry.shared.value, 1)
//
//    _ = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "")
//    
//    XCTAssertEqual(Telemetry.shared.value, 3)
//
//  }
//  
//  class TestRequester: HTTPRequester {
//    
//    var onRequestPerform: (URLRequest) -> Void  = { _ in }
//    
//    init(onRequestPerform: @escaping (URLRequest) -> Void) {
//      self.onRequestPerform = onRequestPerform
//    }
//    
//    struct EmptyError: Error {}
//    
//    func perform<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> TransportTask where T : Decodable {
//      self.onRequestPerform(request)
//      completion(.failure(EmptyError()))
//      return URLSession.shared.dataTask(with: request)
//    }
//    
//  }
//  
//  func testUserAgents() throws {
//    
//    let expectation1 = expectation(description: "URL request expectation")
//    
//    _ = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
//    _ = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "")
//    
//    var expectedUsageValue = ([.hitsSearcher, .facetSearcher] as Telemetry.Usage).rawValue
//    
//    let requester = TestRequester() { request in
//      XCTAssertEqual(Telemetry.shared.value, expectedUsageValue)
//      expectation1.fulfill()
//    }
//    
//    let client = SearchClient(configuration: .init(applicationID: "", apiKey: ""),
//                              requester: requester)
//    
//    do {
//      try client.index(withName: "indexname").search(query: Query())
//    } catch _ {
//    }
//    
//    wait(for: [expectation1], timeout: 5)
//    
//    _ = FilterState()
//    
//    expectedUsageValue = ([.hitsSearcher, .facetSearcher, .filterState] as Telemetry.Usage).rawValue
//    
//    let expectation2 = expectation(description: "URL request expectation")
//    
//    requester.onRequestPerform = { request in
//      XCTAssertEqual(Telemetry.shared.value, expectedUsageValue)
//      expectation2.fulfill()
//    }
//    
//    do {
//      try client.index(withName: "indexname").search(query: Query())
//    } catch _ {
//    }
//    
//    wait(for: [expectation2], timeout: 5)
//    
//  }
  
}

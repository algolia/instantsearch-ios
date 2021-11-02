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
  
  func testMaxSize() {
    let schema = TelemetrySchema.with {
      $0.components = TelemetryComponentType.allCases.map { type in
        TelemetryComponent.with { w in
          w.type = type
          w.isConnector = true
          w.parameters = TelemetryComponentParams.allCases
        }
      }
    }
    let data = try! schema.serializedData()
    print(data.base64EncodedString())
    print(data.count)
  }

  class TestRequester: HTTPRequester {
    
    var onRequestPerform: (URLRequest) -> Void  = { _ in }
    
    init(onRequestPerform: @escaping (URLRequest) -> Void) {
      self.onRequestPerform = onRequestPerform
    }
    
    struct EmptyError: Error {}
    
    func perform<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> TransportTask where T : Decodable {
      self.onRequestPerform(request)
      completion(.failure(EmptyError()))
      return URLSession.shared.dataTask(with: request)
    }
    
  }
  
  func testUserAgents() throws {
    
    let expectation1 = expectation(description: "URL request expectation")
    
    _ = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
    _ = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "")
        
    let requester = TestRequester() { request in
      guard let userAgentValue = request.allHTTPHeaderFields?["User-Agent"] else {
        XCTFail("Missing user-agent value")
        expectation1.fulfill()
        return
      }
      guard let schema = TelemetrySchema(userAgentString: userAgentValue) else {
        XCTFail("Cannot build Schema")
        expectation1.fulfill()
        return
      }
      XCTAssertTrue(schema.components.contains(where: { $0.type == .hitsSearcher }))
      XCTAssertTrue(schema.components.contains(where: { $0.type == .facetSearcher }))
      expectation1.fulfill()
    }
    
    let client = SearchClient(configuration: .init(applicationID: "", apiKey: ""),
                              requester: requester)
    
    do {
      try client.index(withName: "indexname").search(query: Query())
    } catch _ {
    }
    
    wait(for: [expectation1], timeout: 5)
    
    _ = FilterState()
        
    let expectation2 = expectation(description: "URL request expectation")
    
    requester.onRequestPerform = { request in
      guard let userAgentValue = request.allHTTPHeaderFields?["User-Agent"] else {
        XCTFail("Missing user-agent value")
        expectation1.fulfill()
        return
      }
      guard let schema = TelemetrySchema(userAgentString: userAgentValue) else {
        XCTFail("Cannot build Schema")
        expectation1.fulfill()
        return
      }
      XCTAssertTrue(schema.components.contains(where: { $0.type == .hitsSearcher }))
      XCTAssertTrue(schema.components.contains(where: { $0.type == .facetSearcher }))
      XCTAssertTrue(schema.components.contains(where: { $0.type == .filterState }))
      expectation2.fulfill()
    }
    
    do {
      try client.index(withName: "indexname").search(query: Query())
    } catch _ {
    }
    
    wait(for: [expectation2], timeout: 5)
    
  }
  
}

extension TelemetrySchema {
  
  init?(userAgentString: String) {
    let telemetryPrefix = "telemetry: "
    guard let telemetryRange = userAgentString.range(of: "\(telemetryPrefix).+==", options: .regularExpression) else {
      return nil
    }
    let telemetryBase64 = String(userAgentString[telemetryRange].dropFirst(telemetryPrefix.count))
    guard let data = Data(base64Encoded: telemetryBase64) else {
      return nil
    }
    guard let schema = try? TelemetrySchema(serializedData: data) else {
      return nil
    }
    self = schema
  }
 
}

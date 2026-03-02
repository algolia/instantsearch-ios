//
//  OnlineTestCase.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import Search
@testable import InstantSearchCore
import XCTest
/// Abstract base class for online test cases.
///
class OnlineTestCase: XCTestCase {
  struct AlgoliaTask: Codable {
    let id: Int
    enum CodingKeys: String, CodingKey {
      case id = "taskID"
    }
  }

  var expectationTimeout: TimeInterval = 100

  var client: SearchClient!
  var indexName: String!

  override func setUpWithError() throws {
    super.setUp()

    guard let credentials = TestCredentials.search else {
      throw XCTSkip("Missing Algolia credentials (ALGOLIA_APPLICATION_ID_1 / ALGOLIA_ADMIN_KEY_1 environment variables)")
    }

    _ = CoreUserAgentSetter.set

    client = try! SearchClient(appID: credentials.appID, apiKey: credentials.apiKey)

    // NOTE: We use a different index name for each test function.
    let className = String(reflecting: type(of: self)).components(separatedBy: ".").last!
    let functionName = invocation!.selector.description
    let rawName = "\(className).\(functionName)"
    self.indexName = safeIndexName(rawName)

    let deleteExpectation = expectation(description: "Delete index (setup)")
    Task {
      do {
        _ = try await client.deleteIndex(indexName: indexName)
      } catch {
        // Ignore if index doesn't exist.
      }
      deleteExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeout, handler: nil)
  }

  override func tearDown() {
    super.tearDown()

    guard let client, let indexName else { return }

    let expectation = self.expectation(description: "Delete index")
    Task {
      do {
        _ = try await client.deleteIndex(indexName: indexName)
      } catch {
        XCTFail("\(error)")
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeout, handler: nil)
  }

  func fillIndex<O: Encodable>(withItems items: [O], autoGeneratingObjectID: Bool = true, settings: IndexSettings) throws {
    let fillExpectation = expectation(description: "Fill index")
    Task {
      do {
        _ = try await client.saveObjects(indexName: indexName,
                                         objects: items,
                                         waitForTasks: true)
        let settingsResponse = try await client.setSettings(indexName: indexName,
                                                            indexSettings: settings)
        _ = try await client.waitForTask(indexName: indexName,
                                         taskID: settingsResponse.taskID)
      } catch {
        XCTFail("\(error)")
      }
      fillExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeout, handler: nil)
  }
}


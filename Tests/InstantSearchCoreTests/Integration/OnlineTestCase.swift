//
//  OnlineTestCase.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
import AlgoliaSearchClientSwift
/// Abstract base class for online test cases.
///
class OnlineTestCase: XCTestCase {

    struct Task: Codable {
        let id: Int
        enum CodingKeys: String, CodingKey {
            case id = "taskID"
        }
    }

  var expectationTimeout: TimeInterval = 10

  var client: SearchClient!
  var index: Index!

  override func setUpWithError() throws {
    super.setUp()

    // Init client.
    guard let credentials = TestCredentials.search else {
      throw Error.missingCredentials
    }

    client = SearchClient(appID: credentials.applicationID, apiKey: credentials.apiKey)

    // Init index.
    // NOTE: We use a different index name for each test function.
    let className = String(reflecting: type(of: self)).components(separatedBy: ".").last!
    let functionName = invocation!.selector.description
    let indexName = "\(className).\(functionName)"
    index = client.index(withName: safeIndexName(indexName))

    // Delete the index.
    // Although it's not shared with other test functions, it could remain from a previous execution.
    try index.delete().wait()
  }

  override func tearDown() {
    super.tearDown()

    let expectation = self.expectation(description: "Delete index")
    client.index(withName: index.name).delete { result in
      switch result {
      case .failure(let error):
        XCTFail("\(error)")
      case .success:
        break
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeout, handler: nil)
  }

    func fillIndex<O: Encodable>(withItems items: [O], settings: Settings) throws {
      try index.saveObjects(items).wait()
      try index.setSettings(settings).wait()
    }

}

extension OnlineTestCase {
  enum Error: Swift.Error {
    case missingCredentials
  }
}

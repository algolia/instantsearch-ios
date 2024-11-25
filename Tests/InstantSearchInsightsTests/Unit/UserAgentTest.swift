//
//  UserAgentTest.swift
//
//
//  Created by Vladislav Fitc on 03/02/2023.
//

import Search
@testable import InstantSearchInsights
import XCTest

class UserAgentTest: XCTestCase {
  func testUserAgentUniqueness() {
    Insights.register(appId: "a", apiKey: "a")
    Insights.register(appId: "b", apiKey: "b")
    Insights.register(appId: "c", apiKey: "c")
    XCTAssertEqual(UserAgentController.extensions.filter { $0.userAgentExtension.contains("Algolia insights for iOS") }.count, 1)
  }
}

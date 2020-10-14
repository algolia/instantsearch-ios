//
//  UserAgentTests.swift
//  InsightsTests
//
//  Created by Robert Mogos on 11/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class UserAgentTests: XCTestCase {
  
  func testUA() {
    let packageVersion = Bundle(for: WebService.self).infoDictionary!["CFBundleShortVersionString"] as! String
    guard let osInfo = WebService.osInfo() else {
      XCTFail("Unable to fetch the OS info")
      return
    }
    let expectedUserAgent = "insights-ios (\(packageVersion)); \(osInfo.name) (\(osInfo.version))"
    XCTAssertEqual(expectedUserAgent, WebService.computeUserAgent())
  }
}

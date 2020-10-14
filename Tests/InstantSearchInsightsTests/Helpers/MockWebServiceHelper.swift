//
//  HelperMockWS.swift
//  InsightsTests
//
//  Created by Robert Mogos on 12/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchInsights

@objc public class MockWebServiceHelper: NSObject {
    
  static public func getMockWebService(appId: String, _ stub: @escaping (Any) -> ()) -> WebService {
    let logger = Logger(appId)
    let mockWS = MockWebService(sessionConfig: Algolia.SessionConfig.default(appId: "dummyAppId",
                                                                     apiKey: "dummyApiKey"),
                        logger: logger,
                        stub: stub)
    return mockWS
  }
  
  @objc static public func getMockInsights(appId: String, _ stub: @escaping (Any) -> ()) -> Insights {
    let insightsRegister = Insights(credentials: Credentials(appId: "dummyAppId",
                                                             apiKey: "dummyApiKey"),
                                    webService: getMockWebService(appId: appId, stub),
                                    flushDelay: 1,
                                    logger: Logger(appId))
    return insightsRegister
  }
    
}

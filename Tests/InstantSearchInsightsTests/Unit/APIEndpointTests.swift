//
//  APIEndpointTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 29/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

import XCTest
@testable import InstantSearchInsights

class APIEndpointTests: XCTestCase {
    
    func testURLWithRegion() {
        
        let deURL = API.baseURL(forRegion: .de)
        XCTAssertEqual(deURL, URL(string: "https://insights.de.algolia.io"))
        
        let usURL = API.baseURL(forRegion: .us)
        XCTAssertEqual(usURL, URL(string: "https://insights.us.algolia.io"))

    }
    
    func testRegionPropagation() {
        
        let url = API.baseURL(forRegion: .none)
        XCTAssertEqual(url, URL(string: "https://insights.algolia.io"))
        
        Insights.region = .us
        let usURL = API.baseURL(forRegion: .none)
        XCTAssertEqual(usURL, URL(string: "https://insights.us.algolia.io"))
        
        Insights.region = .none
        
        let anotherURL = API.baseURL(forRegion: .none)
        XCTAssertEqual(anotherURL, URL(string: "https://insights.algolia.io"))

    }
    
}

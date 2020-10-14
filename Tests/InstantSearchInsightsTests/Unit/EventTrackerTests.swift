//
//  EventTrackerTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventTrackerTests: XCTestCase {
    
    let eventProcessor = TestEventProcessor()
    let logger = Logger("test app id")
    var eventTracker: EventTracker!
    
    override func setUp() {
        eventTracker = EventTracker(eventProcessor: eventProcessor, logger: logger)
    }
    
    func testViewEventWithObjects() {

        let expected = InsightsTests.Expected()
        
        let exp = expectation(description: "Wait for event processor callback")

        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let view = e as? ViewEvent else {
                XCTFail("View event expected")
                return
            }
            XCTAssertEqual(view.indexName, expected.indexName)
            XCTAssertEqual(view.name, expected.eventName)
            XCTAssertEqual(view.userToken, expected.userToken)
            XCTAssertNil(view.queryID)
            XCTAssertEqual(view.objectIDsOrFilters, .objectIDs(expected.objectIDs))
        }

        eventTracker.view(eventName: expected.eventName,
                          indexName: expected.indexName,
                          userToken: expected.userToken,
                          objectIDs: expected.objectIDs)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testViewEventWithFilters() {
        
        let expected = InsightsTests.Expected()

        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let view = e as? ViewEvent else {
                XCTFail("View event expected")
                return
            }
            XCTAssertEqual(view.indexName, expected.indexName)
            XCTAssertEqual(view.name, expected.eventName)
            XCTAssertEqual(view.userToken, expected.userToken)
            XCTAssertNil(view.queryID)
            XCTAssertEqual(view.objectIDsOrFilters, .filters(expected.filters))
            
        }
        
        eventTracker.view(eventName: expected.eventName,
                          indexName: expected.indexName,
                          userToken: expected.userToken,
                          filters: expected.filters)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testClickEventWithObjects() {
        
        let expected = InsightsTests.Expected()
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let click = e as? ClickEvent else {
                XCTFail("Click event expected")
                return
            }
            XCTAssertEqual(click.indexName, expected.indexName)
            XCTAssertEqual(click.name, expected.eventName)
            XCTAssertEqual(click.userToken, expected.userToken)
            XCTAssertNil(click.queryID)
            XCTAssertEqual(click.objectIDsOrFilters, .objectIDs(expected.objectIDs))
            
        }
        
        eventTracker.click(eventName: expected.eventName,
                           indexName: expected.indexName,
                           userToken: expected.userToken,
                           objectIDs: expected.objectIDs)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testClickEventWithFilters() {
        
        let expected = InsightsTests.Expected()
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let click = e as? ClickEvent else {
                XCTFail("Click event expected")
                return
            }
            XCTAssertEqual(click.indexName, expected.indexName)
            XCTAssertEqual(click.name, expected.eventName)
            XCTAssertEqual(click.userToken, expected.userToken)
            XCTAssertNil(click.queryID)
            XCTAssertEqual(click.objectIDsOrFilters, .filters(expected.filters))
            
        }
        
        eventTracker.click(eventName: expected.eventName,
                           indexName: expected.indexName,
                           userToken: expected.userToken,
                           filters: expected.filters)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testConversionEventWithObjects() {
        
        let expected = InsightsTests.Expected()
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let conversion = e as? ConversionEvent else {
                XCTFail("Conversion event expected")
                return
            }
            XCTAssertEqual(conversion.indexName, expected.indexName)
            XCTAssertEqual(conversion.name, expected.eventName)
            XCTAssertEqual(conversion.userToken, expected.userToken)
            XCTAssertNil(conversion.queryID)
            XCTAssertEqual(conversion.objectIDsOrFilters, .objectIDs(expected.objectIDs))
        }
        
        eventTracker.conversion(eventName: expected.eventName,
                                indexName: expected.indexName,
                                userToken: expected.userToken,
                                objectIDs: expected.objectIDs)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testConversionEventWithFilters() {
        
        let expected = InsightsTests.Expected()

        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let conversion = e as? ConversionEvent else {
                XCTFail("Conversion event expected")
                return
            }
            XCTAssertEqual(conversion.indexName, expected.indexName)
            XCTAssertEqual(conversion.name, expected.eventName)
            XCTAssertEqual(conversion.userToken, expected.userToken)
            XCTAssertNil(conversion.queryID)
            XCTAssertEqual(conversion.objectIDsOrFilters, .filters(expected.filters))
            
        }
        
        eventTracker.conversion(eventName: expected.eventName,
                                indexName: expected.indexName,
                                userToken: expected.userToken,
                                filters: expected.filters)
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
}


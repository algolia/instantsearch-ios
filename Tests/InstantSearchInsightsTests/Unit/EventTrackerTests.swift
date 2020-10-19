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
  var eventTracker: EventTracker!
  
  override func setUp() {
    eventTracker = EventTracker(eventProcessor: eventProcessor, logger: Logger(prefix: "EventTrackerTests"))
  }
  
  func testViewEventWithObjects() {
    
    let exp = expectation(description: "Wait for event processor callback")
    
    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.type, .view)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.name, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.resources, .objectIDs(TestEvent.objectIDs))
      exp.fulfill()
    }
    
    eventTracker.view(eventName: TestEvent.eventName,
                      indexName: TestEvent.indexName,
                      userToken: TestEvent.userToken,
                      objectIDs: TestEvent.objectIDs)
    
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testViewEventWithFilters() {
        
    let exp = expectation(description: "Wait for event processor callback")
    
    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.type, .view)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.name, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.resources, .filters(TestEvent.filters))
      exp.fulfill()
    }
    
    eventTracker.view(eventName: TestEvent.eventName,
                      indexName: TestEvent.indexName,
                      userToken: TestEvent.userToken,
                      filters: TestEvent.filters)
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testClickEventWithObjects() {
        
    let exp = expectation(description: "Wait for event processor callback")
    
    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.type, .click)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.name, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.resources, .objectIDs(TestEvent.objectIDs))
      exp.fulfill()
    }
    
    eventTracker.click(eventName: TestEvent.eventName,
                       indexName: TestEvent.indexName,
                       userToken: TestEvent.userToken,
                       objectIDs: TestEvent.objectIDs)
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testClickEventWithFilters() {
        
    let exp = expectation(description: "Wait for event processor callback")
    
    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.type, .click)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.name, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.resources, .filters(TestEvent.filters))
      exp.fulfill()
    }
    
    eventTracker.click(eventName: TestEvent.eventName,
                       indexName: TestEvent.indexName,
                       userToken: TestEvent.userToken,
                       filters: TestEvent.filters)
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testConversionEventWithObjects() {
        
    let exp = expectation(description: "Wait for event processor callback")
    
    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.type, .conversion)
      
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.name, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.resources, .objectIDs(TestEvent.objectIDs))
      exp.fulfill()
    }
    
    eventTracker.conversion(eventName: TestEvent.eventName,
                            indexName: TestEvent.indexName,
                            userToken: TestEvent.userToken,
                            objectIDs: TestEvent.objectIDs)
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testConversionEventWithFilters() {
        
    let exp = expectation(description: "Wait for event processor callback")
    
    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.type, .conversion)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.name, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.resources, .filters(TestEvent.filters))
      exp.fulfill()
      
    }
    
    eventTracker.conversion(eventName: TestEvent.eventName,
                            indexName: TestEvent.indexName,
                            userToken: TestEvent.userToken,
                            filters: TestEvent.filters)
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
}


//
//  EventsProcessorTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventsProcessorTests: XCTestCase {
    
    let appId = "test app id"
    
    override func setUp() {
        //Remove locally stored events packages
        let fileName = "\(appId).events"
        if let fp = LocalStorage<[EventsPackage]>.filePath(for: fileName) {
            LocalStorage<[EventsPackage]>.serialize([], file: fp)
        }
    }
    
    func testOptOut() {
        
        let exp = expectation(description: "ws call")
        exp.isInverted = true
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in
            exp.fulfill()
        }
        
        let queue = DispatchQueue(label: "test queue", qos: .default)
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsProcessor = EventProcessor(credentials: credentials,
                                              webService: mockWS,
                                              region: .none,
                                              flushDelay: 1000,
                                              logger: Logger(appId),
                                              dispatchQueue: queue)
        
        // Expectation must no be fullfilled as eventsProcessor is deactivated
        
        eventsProcessor.isActive = false
        eventsProcessor.process(TestEvent.template)
        queue.sync {}
        XCTAssertTrue(eventsProcessor.eventsPackages.isEmpty)
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testOptOutOptIn() {
        
        let exp = expectation(description: "ws call")
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in
            exp.fulfill()
        }
        
        let queue = DispatchQueue(label: "test queue", qos: .default)
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsProcessor = EventProcessor(credentials: credentials,
                                              webService: mockWS,
                                              region: .none,
                                              flushDelay: 1000,
                                              logger: Logger(appId),
                                              dispatchQueue: queue)
        
        eventsProcessor.isActive = false
        eventsProcessor.isActive = true
        eventsProcessor.process(TestEvent.template)
        queue.sync {}
        XCTAssertFalse(eventsProcessor.eventsPackages.isEmpty)
        eventsProcessor.flush()
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    
    func testPackageAssembly() {
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in }
        
        let queue = DispatchQueue(label: "test queue", qos: .default)
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsProcessor = EventProcessor(credentials: credentials,
                                              webService: mockWS,
                                              region: .none,
                                              flushDelay: 1000,
                                              logger: Logger(appId),
                                              dispatchQueue: queue)
        
        eventsProcessor.isLocalStorageEnabled = false
        eventsProcessor.process(TestEvent.template)
        
        queue.sync {}
        XCTAssertEqual(eventsProcessor.eventsPackages.count, 1)

        eventsProcessor.process(TestEvent.template)
        
        queue.sync {}
        
        XCTAssertEqual(eventsProcessor.eventsPackages.count, 1)
        XCTAssertEqual(eventsProcessor.eventsPackages.first?.events.count, 2)
        
        print(eventsProcessor.eventsPackages)
        
        let events = [Event](repeating: TestEvent.template, count: EventsPackage.maxEventCountInPackage)
        
        events.forEach(eventsProcessor.process)
        
        queue.sync {}
        
        print(eventsProcessor.eventsPackages)
        
        XCTAssertEqual(eventsProcessor.eventsPackages.count, 2)
        XCTAssertEqual(eventsProcessor.eventsPackages.first?.count, EventsPackage.maxEventCountInPackage)
        XCTAssertEqual(eventsProcessor.eventsPackages.last?.count, 2)
        
    }
    
    func testSync() {
        
        let exp = expectation(description: "expectation for ws response")
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in
            exp.fulfill()
        }
        let queue = DispatchQueue(label: "test queue")
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsProcessor = EventProcessor(credentials: credentials,
                                              webService: mockWS,
                                              region: .none,
                                              flushDelay: 1000,
                                              logger: Logger(appId),
                                              dispatchQueue: queue)
        
        eventsProcessor.isLocalStorageEnabled = false

        eventsProcessor.process(TestEvent.template)
        queue.sync {}
        eventsProcessor.flush()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

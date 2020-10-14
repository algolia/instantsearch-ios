//
//  ObjectIDsOrFiltersTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class ObjectIDsOrFiltersTests: XCTestCase {
    
    func testObjectIDsEncoding() {
        let rawObjectIDs = ["o1", "o2", "o3"]
        let objectIDs = ObjectsIDsOrFilters.objectIDs(rawObjectIDs)
        let serializedObjectIDs = Dictionary(objectIDs)!
        let expectedSerializedObjectIDs: Dictionary<String, Any> = [ObjectsIDsOrFilters.CodingKeys.objectIDs.rawValue: rawObjectIDs]
        XCTAssertTrue(NSDictionary(dictionary: serializedObjectIDs).isEqual(to: expectedSerializedObjectIDs))
    }
    
    func testFiltersEncoding() {
        let rawFilters = ["f1", "f2", "f3"]
        let filters = ObjectsIDsOrFilters.filters(rawFilters)
        let serializedFilters = Dictionary(filters)!
        let expectedSerializedFilters: Dictionary<String, Any> = [ObjectsIDsOrFilters.CodingKeys.filters.rawValue: rawFilters]
        XCTAssertTrue(NSDictionary(dictionary: serializedFilters).isEqual(to: expectedSerializedFilters))
    }
    
    func testObjectIDsDecoding() {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: [ObjectsIDsOrFilters.CodingKeys.objectIDs.rawValue: ["o1", "o2", "o3"]], options: [])
            let objectIDs = try JSONDecoder().decode(ObjectsIDsOrFilters.self, from: jsonData)
            let expectedObjectIDs = ObjectsIDsOrFilters.objectIDs(["o1", "o2", "o3"])
            XCTAssertEqual(objectIDs, expectedObjectIDs)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testFiltersDecoding() {
        let rawFilters = ["f1", "f2", "f3"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: [ObjectsIDsOrFilters.CodingKeys.filters.rawValue: rawFilters], options: [])
            let filters = try JSONDecoder().decode(ObjectsIDsOrFilters.self, from: jsonData)
            let expectedFilters = ObjectsIDsOrFilters.filters(rawFilters)
            XCTAssertEqual(filters, expectedFilters)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testFailedDecoding() {
        
        let data = try! JSONSerialization.data(withJSONObject: ["a": "b"], options: [])
        
        let jsonDecoder = JSONDecoder()
        
        do {
            _ = try jsonDecoder.decode(ObjectsIDsOrFilters.self, from: data)
        } catch let error {
            XCTAssertEqual(error as? ObjectsIDsOrFilters.Error, ObjectsIDsOrFilters.Error.decodingFailure)
            XCTAssertEqual(error.localizedDescription, "Neither \(ObjectsIDsOrFilters.CodingKeys.filters.rawValue), nor \(ObjectsIDsOrFilters.CodingKeys.objectIDs.rawValue) key found on decoder"
)
        }
        
    }
    
}

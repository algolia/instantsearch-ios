//
//  DecodingErrorPrettyPrinterTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 12/02/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class DecodingErrorPrettyPrinterTests: XCTestCase {
  struct Person: Codable {
    let name: String
    let age: Int
  }

  func testValueNotFound() {
    let data = """
    {
      "name": "Alex Smith",
      "age": null
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()

    do {
      _ = try decoder.decode(Person.self, from: data)
    } catch {
      guard let decodingError = error as? DecodingError else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      let prettyPrinter = DecodingErrorPrettyPrinter(decodingError: decodingError)
      XCTAssertTrue(
        prettyPrinter.description
          == "Decoding error: 'age': Expected Int value but found null instead."
          || prettyPrinter.description
            == "Decoding error: 'age': Cannot get unkeyed decoding container -- found null value instead"
      )
    }
  }

  func testKeyNotFound() {
    let data = """
    {
      "name": "Alex Smith",
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()

    do {
      _ = try decoder.decode(Person.self, from: data)
    } catch {
      guard let decodingError = error as? DecodingError else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      let prettyPrinter = DecodingErrorPrettyPrinter(decodingError: decodingError)
      XCTAssertEqual(prettyPrinter.description, "Decoding error: : Key not found: 'age'")
    }
  }

  func testTypeMismatch() {
    let data = """
    {
      "name": "Alex Smith",
      "age": "AGE"
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()

    do {
      _ = try decoder.decode(Person.self, from: data)
    } catch {
      guard let decodingError = error as? DecodingError else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      let prettyPrinter = DecodingErrorPrettyPrinter(decodingError: decodingError)

      XCTAssertEqual(prettyPrinter.description, "Decoding error: 'age': Type mismatch. Expected: Int")
    }
  }

  func testDataCorrupted() {
    let data = """
    {
      ___
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()

    do {
      _ = try decoder.decode(Person.self, from: data)
    } catch {
      guard let decodingError = error as? DecodingError else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      let prettyPrinter = DecodingErrorPrettyPrinter(decodingError: decodingError)
      XCTAssertEqual(prettyPrinter.description, "Decoding error: : The given data was not valid JSON.")
    }
  }
}

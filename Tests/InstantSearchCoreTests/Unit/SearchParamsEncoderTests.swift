//
//  SearchParamsEncoderTests.swift
//  InstantSearchCoreTests
//

import XCTest
import AlgoliaSearch
@testable import InstantSearchCore

final class SearchParamsEncoderTests: XCTestCase {
  /// Values containing `&` must be percent-encoded so that the resulting `params` string can be split on `&`
  /// to recover the original `key=value` pairs. Otherwise the server interprets the tail as an unknown
  /// parameter (see issue where `facetFilters` values like "Dates & Dried Fruits" caused HTTP 400
  /// `Unknown parameter` errors).
  func testEncodingEscapesAmpersandInFacetFilterValues() throws {
    var params = SearchSearchParamsObject()
    params.query = "Pepsi"
    params.facetFilters = .arrayOfSearchFacetFilters([
      .string("categoryEnglishPath:\"Turbomart>>Fruits>>Dates & Dried Fruits\""),
    ])

    let encoded = try XCTUnwrap(SearchParamsEncoder.encode(params))

    XCTAssertFalse(
      encoded.contains("Dates & Dried"),
      "Raw '&' in a value would break query-string parsing on the server; got: \(encoded)"
    )
    XCTAssertTrue(
      encoded.contains("%26"),
      "Expected '&' to be percent-encoded as %26; got: \(encoded)"
    )

    let pairs = encoded
      .split(separator: "&")
      .map { $0.split(separator: "=", maxSplits: 1).map(String.init) }

    for pair in pairs {
      XCTAssertEqual(pair.count, 2, "Every pair should split cleanly into key=value")
    }

    let facetFiltersPair = try XCTUnwrap(pairs.first { $0.first == "facetFilters" })
    let decodedValue = try XCTUnwrap(facetFiltersPair[1].removingPercentEncoding)
    XCTAssertTrue(
      decodedValue.contains("Dates & Dried Fruits"),
      "After percent-decoding the value should match the original filter string; got: \(decodedValue)"
    )
  }

  /// The sub-delimiters listed in RFC 3986 that could otherwise be mistaken for separators when the
  /// server re-parses the `params` query string.
  func testEncodingEscapesReservedSubDelimitersInValues() throws {
    var params = SearchSearchParamsObject()
    params.facetFilters = .arrayOfSearchFacetFilters([
      .string("attr:a=b+c?d#e;f/g@h"),
    ])

    let encoded = try XCTUnwrap(SearchParamsEncoder.encode(params))
    let facetPair = try XCTUnwrap(
      encoded.split(separator: "&").first { $0.hasPrefix("facetFilters=") }
    )
    let value = facetPair.dropFirst("facetFilters=".count)

    for reserved in ["=", "+", "?", "#", ";", "/", "@"] {
      XCTAssertFalse(
        value.contains(reserved),
        "Expected reserved character '\(reserved)' to be percent-encoded; got: \(value)"
      )
    }

    let decoded = try XCTUnwrap(String(value).removingPercentEncoding)
    for reserved in ["=", "+", "?", "#", ";", "@"] {
      XCTAssertTrue(
        decoded.contains(reserved),
        "Round-trip decoding should preserve reserved character '\(reserved)'; got: \(decoded)"
      )
    }
  }
}

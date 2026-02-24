//
//  FilterFacetParsing.swift
//  InstantSearchInsights
//

import Foundation

extension FilterFacet {
  /// Parse a single filter string into a typed FilterFacet.
  /// Supported forms: attribute:value, attribute:-value, attribute:"value with spaces", attribute:-"value", attribute:value<score=10>
  static func parse(_ filter: String) -> FilterFacet? {
    guard let colonIndex = filter.firstIndex(of: ":") else {
      return nil
    }
    let attribute = String(filter[..<colonIndex]).trimmingCharacters(in: .whitespaces)
    guard !attribute.isEmpty else { return nil }

    var valuePart = String(filter[filter.index(after: colonIndex)...]).trimmingCharacters(in: .whitespaces)
    var score: Int? = nil

    if let scoreRange = valuePart.range(of: "<score=") {
      let scoreSuffix = valuePart[scoreRange.lowerBound...]
      if scoreSuffix.hasPrefix("<score="), scoreSuffix.hasSuffix(">") {
        let scoreValue = scoreSuffix.dropFirst("<score=".count).dropLast()
        score = Int(scoreValue)
        valuePart = String(valuePart[..<scoreRange.lowerBound]).trimmingCharacters(in: .whitespaces)
      }
    }

    var isNegated = false
    if valuePart.hasPrefix("-") {
      isNegated = true
      valuePart.removeFirst()
      valuePart = valuePart.trimmingCharacters(in: .whitespaces)
    }

    let unquotedValue: String
    if valuePart.hasPrefix("\""), valuePart.hasSuffix("\""), valuePart.count >= 2 {
      let inner = valuePart.dropFirst().dropLast()
      unquotedValue = inner.replacingOccurrences(of: "\\\"", with: "\"")
    } else {
      unquotedValue = valuePart
    }

    let typedValue: FilterFacet.Value
    let lowercased = unquotedValue.lowercased()
    if lowercased == "true" || lowercased == "false" {
      typedValue = .bool(lowercased == "true")
    } else if let number = Double(unquotedValue) {
      typedValue = .number(number)
    } else {
      typedValue = .string(unquotedValue)
    }

    return FilterFacet(attribute: attribute, value: typedValue, isNegated: isNegated, score: score)
  }

  static func parseFilters(_ filters: [String]) -> [FilterFacet] {
    return filters.compactMap(parse)
  }
}

extension FilterFacet {
  /// Convert to legacy filter string representation.
  func legacyString() -> String {
    let valueString: String
    switch value {
    case let .string(value):
      let needsQuoting = value.contains(" ") || value.contains(":")
      let escaped = value.replacingOccurrences(of: "\"", with: "\\\"")
      valueString = needsQuoting ? "\"\(escaped)\"" : escaped
    case let .number(value):
      valueString = String(value)
    case let .bool(value):
      valueString = value ? "true" : "false"
    }
    let scoreSuffix = score.flatMap { "<score=\($0)>" } ?? ""
    let prefix = isNegated ? "-" : ""
    return "\(attribute):\(prefix)\(valueString)\(scoreSuffix)"
  }
}



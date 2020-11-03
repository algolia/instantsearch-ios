//
//  Hit+Place.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 24/10/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension Hit {

  func getBestHighlightedForm(from highlightResults: [HighlightResult]) -> HighlightedString? {

    guard let defaultValue = highlightResults.first?.value.taggedString.input else { return nil }

    let bestAttributesOrder = highlightResults
      .filter { $0.matchLevel != .none }
      .enumerated()
      .sorted { lhs, rhs in
        // If matched words count is the same, use the earliest occurency in the list
        guard lhs.element.matchedWords.count != rhs.element.matchedWords.count else {
          return lhs.offset < rhs.offset
        }
        return lhs.element.matchedWords.count > rhs.element.matchedWords.count
      }
      .map { $0.offset }
      .first

    guard let theBestAttributeIndex = bestAttributesOrder else { return HighlightedString(string: defaultValue) }

    return highlightResults[theBestAttributeIndex].value

  }

  func getBestHighlightedForm(forKey key: String) -> HighlightedString? {

    guard case .dictionary(let dictionary) = highlightResult  else {
      return nil
    }

    let highlightResults: [HighlightResult]

    switch dictionary[key] {
    case .array(let highlightResultsList):
      highlightResults = highlightResultsList.compactMap {
        if case .value(let val) = $0 {
          return val
        } else {
          return nil
        }
      }

    case .value(let value):
      highlightResults = [value]

    default:
      return nil
    }

    return getBestHighlightedForm(from: highlightResults)

  }

}

extension Hit: CustomStringConvertible where T == Place {

  public var description: String {
    let cityKey = object.isCity! ? "locale_names" : "city"
    let country = getBestHighlightedForm(forKey: "country")
    let county = getBestHighlightedForm(forKey: "county")
    let city = getBestHighlightedForm(forKey: cityKey)
    let streetName = object.isCity! ? nil : getBestHighlightedForm(forKey: "locale_names")

    return [streetName, city, county, country]
      .compactMap { $0 }
      .filter { !$0.taggedString.input.isEmpty }
      .map { highlightedString in
        var taggedString = highlightedString.taggedString
        return taggedString.output
      }
      .joined(separator: ", ")

  }

}

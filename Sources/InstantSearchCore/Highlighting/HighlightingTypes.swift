//
//  HighlightingTypes.swift
//  InstantSearchCore
//

import Foundation
import Search

/// Represents a string with highlight tags and computed highlight ranges.
public struct TaggedString: Hashable {
  public let input: String
  public let output: String
  public let taggedRanges: [Range<String.Index>]
  public let untaggedRanges: [Range<String.Index>]

  public init(input: String) {
    self.input = input

    var output = ""
    var taggedRanges: [Range<String.Index>] = []

    var cursor = input.startIndex
    var currentTaggedStart: String.Index?
    var isTagged = false

    while cursor < input.endIndex {
      if input[cursor] == "<", let tagEnd = input[cursor...].firstIndex(of: ">") {
        let tagContent = input[input.index(after: cursor)..<tagEnd]
        let isClosingTag = tagContent.hasPrefix("/")
        if isClosingTag {
          if isTagged, let start = currentTaggedStart {
            taggedRanges.append(start..<output.endIndex)
          }
          isTagged = false
          currentTaggedStart = nil
        } else if !isTagged {
          currentTaggedStart = output.endIndex
          isTagged = true
        }
        cursor = input.index(after: tagEnd)
        continue
      }

      output.append(input[cursor])
      cursor = input.index(after: cursor)
    }

    if isTagged, let start = currentTaggedStart {
      taggedRanges.append(start..<output.endIndex)
    }

    let untaggedRanges = TaggedString.computeUntaggedRanges(output: output, taggedRanges: taggedRanges)

    self.output = output
    self.taggedRanges = taggedRanges
    self.untaggedRanges = untaggedRanges
  }
}

/// Represents a highlighted string with parsed tag ranges.
public struct HighlightedString: Hashable {
  public let string: String
  public let taggedString: TaggedString

  public init(string: String) {
    self.string = string
    taggedString = TaggedString(input: string)
  }
}

public extension SearchHighlightResult {
  /// Extract a highlighted string if the value is a single highlight option.
  var highlightedString: HighlightedString? {
    guard case let .searchHighlightResultOption(option) = self else { return nil }
    return HighlightedString(string: option.value)
  }

  /// Extract nested highlight results when the value is an array.
  var arrayValue: [SearchHighlightResult]? {
    guard case let .arrayOfSearchHighlightResult(results) = self else { return nil }
    return results
  }

  /// Extract nested highlight results when the value is a dictionary.
  var dictionaryValue: [String: SearchHighlightResult]? {
    guard case let .dictionaryOfStringToSearchHighlightResult(results) = self else { return nil }
    return results
  }
}

private extension TaggedString {
  static func computeUntaggedRanges(output: String, taggedRanges: [Range<String.Index>]) -> [Range<String.Index>] {
    guard !output.isEmpty else { return [] }
    let sortedTaggedRanges = taggedRanges.sorted { $0.lowerBound < $1.lowerBound }
    var untagged: [Range<String.Index>] = []
    var cursor = output.startIndex
    for range in sortedTaggedRanges {
      if cursor < range.lowerBound {
        untagged.append(cursor..<range.lowerBound)
      }
      cursor = range.upperBound
    }
    if cursor < output.endIndex {
      untagged.append(cursor..<output.endIndex)
    }
    return untagged
  }
}


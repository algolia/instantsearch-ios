//
//  HighlightedText.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension SwiftUI.Text {

  /**
   - parameter highlightedString: HighlightedString value
   - parameter regular: Text builder for a regular string
   - parameter highlighted: Text builder for a highlighted string
   */
  init(highlightedString: HighlightedString,
       @ViewBuilder regular: @escaping (String) -> Text = { Text($0) },
       @ViewBuilder highlighted: @escaping (String) -> Text) {
    self.init(taggedString: highlightedString.taggedString,
              regular: regular,
              tagged: highlighted)
  }

  /**
   - parameter taggedString: TaggedString value
   - parameter regular: Text builder for a regular string
   - parameter tagged: Text builder for a tagged string
   */
  init(taggedString: TaggedString,
       @ViewBuilder regular: @escaping (String) -> Text = { Text($0) },
       @ViewBuilder tagged: @escaping (String) -> Text) {

    var mutableTaggedString = taggedString

    let taggedRanges = mutableTaggedString.taggedRanges.map { ($0, true) }
    let untaggedRanges = mutableTaggedString.untaggedRanges.map { ($0, false) }

    func text(for range: Range<String.Index>, isHighlighted: Bool) -> Text {
      let string = String(mutableTaggedString.output[range])
      return isHighlighted ? tagged(string) : regular(string)
    }

    self = (taggedRanges + untaggedRanges)
      // Sort ranges by lower bound
      .sorted { $0.0.lowerBound < $1.0.lowerBound }
      .map(text)
      .reduce(Text(""), +)
  }

}

#if os(iOS)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct HighlightedText_Previews: PreviewProvider {

  static let input = """
  Hello <em>darkness</em>, my old friend
  I've come to <em>talk</em> with you again
  Because a vision softly <em>creeping</em>
  Left <em>its</em> seeds <em>while</em> I was sleeping
  """

  static var previews: some View {
    let highlightedString = HighlightedString(string: input)
    Text(highlightedString: highlightedString) { str -> Text in
      Text(str).foregroundColor(.black).font(.body)
    } highlighted: { str -> Text in
      Text(str).foregroundColor(.green).font(.headline)
    }
  }

}
#endif
#endif

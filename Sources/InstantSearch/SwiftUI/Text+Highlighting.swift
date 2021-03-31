//
//  HighlightedText.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Text {
  
  init(highlightedString: HighlightedString,
       @ViewBuilder regular: @escaping (String) -> Text = { Text($0) },
       @ViewBuilder highlighted: @escaping (String) -> Text) {
    self.init(taggedString: highlightedString.taggedString, regular: regular, highlighted: highlighted)
  }
  
  init(taggedString: TaggedString,
       @ViewBuilder regular: @escaping (String) -> Text = { Text($0) },
       @ViewBuilder highlighted: @escaping (String) -> Text) {
    
    var mutableTaggedString = taggedString
    
    let taggedRanges = mutableTaggedString.taggedRanges.map { ($0, true) }
    let untaggedRanges = mutableTaggedString.untaggedRanges.map { ($0, false) }
    
    func text(for range: Range<String.Index>, isHighlighted: Bool) -> Text {
      let string = String(mutableTaggedString.output[range])
      return isHighlighted ? highlighted(string) : regular(string)
    }
    
    self = (taggedRanges + untaggedRanges)
      // Sort ranges by lower bound
      .sorted { (l, r) in l.0.lowerBound < r.0.lowerBound }
      .map(text)
      .reduce(Text(""), +)
  }
  
}


#if os(iOS)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct HighlightedText_Previews : PreviewProvider {
  
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

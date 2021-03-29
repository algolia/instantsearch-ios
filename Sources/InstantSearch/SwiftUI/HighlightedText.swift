//
//  HighlightedText.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct HighlightedText: View {
  
  let highlightedString: TaggedString
  let regular: (String) -> Text
  let highlighted: (String) -> Text
  
  init(highlightedString: TaggedString,
       @ViewBuilder regular: @escaping (String) -> Text = { Text($0) },
       @ViewBuilder highlighted: @escaping (String) -> Text) {
    self.highlightedString = highlightedString
    self.regular = regular
    self.highlighted = highlighted
    
  }
  
  var body: some View {
    Text("Hey")
  }

}

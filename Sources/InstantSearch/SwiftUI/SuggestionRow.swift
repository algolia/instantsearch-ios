//
//  SuggestionRow.swift
//  
//
//  Created by Vladislav Fitc on 01/04/2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SuggestionRow: View {

  public let text: String
  public var onTypeAhead: (String) -> Void
  public var onSelection: (String) -> Void
  
  public init(text: String,
              onSelection: @escaping (String) -> Void,
              onTypeAhead: @escaping (String) -> Void) {
    self.text = text
    self.onSelection = onSelection
    self.onTypeAhead = onTypeAhead
  }
  
  public var body: some View {
    HStack {
      Text(text)
        .padding(.vertical, 3)
      Spacer()
      Button(action: { onTypeAhead(text) }) {
        Image(systemName: "arrow.up.backward").foregroundColor(.gray)
      }
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 20)
    .contentShape(Rectangle())
    .onTapGesture {
      onSelection(text)
    }
  }
  
}

//
//  SuggestionRow.swift
//  
//
//  Created by Vladislav Fitc on 01/04/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// A view presenting a search query suggestion
@available(iOS 13.0, OSX 11.0, tvOS 13.0, watchOS 6.0, *)
public struct SuggestionRow: View {

  /// Suggestion
  public let suggestion: QuerySuggestion

  /// An action triggered when typeahead button (arrow) tapped
  public var onTypeAhead: (String) -> Void

  /// An action triggered when suggestion selected
  public var onSelection: (String) -> Void

  private func valueText(for suggestion: QuerySuggestion) -> Text {
    if let highlightedValue = suggestion.highlighted {
      let highlightedValueString = HighlightedString(string: highlightedValue)
      return Text(highlightedString: highlightedValueString) { Text($0).bold() }
    } else {
      return Text(suggestion.query)
    }
  }

  public init(suggestion: QuerySuggestion,
              onSelection: @escaping (String) -> Void,
              onTypeAhead: @escaping (String) -> Void) {
    self.suggestion = suggestion
    self.onSelection = onSelection
    self.onTypeAhead = onTypeAhead
  }

  public var body: some View {
    let stack =
    HStack {
      valueText(for: suggestion)
        .padding(.vertical, 3)
      Spacer()
      Button(action: {
              onTypeAhead(suggestion.query)
             },
             label: {
              Image(systemName: "arrow.up.backward")
                .foregroundColor(.gray)
             })
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 20)
    .contentShape(Rectangle())
    #if os(tvOS)
      return stack
    #else
      return stack
        .onTapGesture {
          onSelection(suggestion.query)
        }
    #endif
  }

}
#endif

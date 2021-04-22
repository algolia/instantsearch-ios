//
//  FacetRow.swift
//  
//
//  Created by Vladislav Fitc on 20/04/2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 11.00, tvOS 13.0, watchOS 6.0, *)
public struct FacetRow: View {

  public var facet: Facet
  public var isSelected: Bool

  func valueText(for facet: Facet) -> Text {
    if let highlightedValue = facet.highlighted {
      let highlightedValueString = HighlightedString(string: highlightedValue)
      return Text(highlightedString: highlightedValueString) { Text($0).bold() }
    } else {
      return Text(facet.value)
    }
  }

  public var body: some View {
    HStack(spacing: 0) {
      (valueText(for: facet) + Text(" (\(facet.count))"))
      Spacer()
      if isSelected {
        Image(systemName: "checkmark")
          .frame(maxHeight: .infinity, alignment: .trailing)
          .foregroundColor(.accentColor)
      }
    }
    .contentShape(Rectangle())
  }

  public init(facet: Facet, isSelected: Bool) {
    self.facet = facet
    self.isSelected = isSelected
  }

}

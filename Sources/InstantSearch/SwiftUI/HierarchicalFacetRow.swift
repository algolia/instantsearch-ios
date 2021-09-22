//
//  HierarchicalFacetRow.swift
//  
//
//  Created by Vladislav Fitc on 29/06/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

@available(iOS 13.0, OSX 11.00, tvOS 13.0, watchOS 6.0, *)
public struct HierarchicalFacetRow: View {

  /// Facet value
  public var facet: Facet

  /// Facet selection state
  public var isSelected: Bool

  /// Facet nesting level in the hierarchy
  public var nestingLevel: Int

  /// Character separating the facets in the hierarchical facet
  ///
  /// Default value: ">"
  public var separator: Character

  public var body: some View {
    HStack(spacing: 10) {
      Image(systemName: isSelected ? "chevron.down" : "chevron.right")
        .font(.callout)
      let displayFacetValue = facet
        .value
        .split(separator: separator)
        .map { $0.trimmingCharacters(in: .whitespaces) }.last ?? ""
      Text("\(displayFacetValue) (\(facet.count))")
        .fontWeight(isSelected ? .semibold : .regular)
        .contentShape(Rectangle())
      Spacer()
    }
    .padding(.leading, CGFloat(nestingLevel * 20))
  }

  public init(facet: Facet,
              nestingLevel: Int,
              isSelected: Bool,
              separator: Character = ">") {
    self.facet = facet
    self.nestingLevel = nestingLevel
    self.isSelected = isSelected
    self.separator = separator
  }

}
#endif

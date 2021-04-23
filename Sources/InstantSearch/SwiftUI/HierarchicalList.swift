//
//  HierarchicalList.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation
import SwiftUI

#if os(iOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct HierarchicalList: View {

  @ObservedObject var hierarchicalController: HierarchicalObservableController

  public var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      ForEach(hierarchicalController.items.prefix(20), id: \.facet) { item in
        let (_, level, isSelected) = item
        let facet = self.facet(from: item)
        HStack(spacing: 10) {
          Image(systemName: isSelected ? "chevron.down" : "chevron.right")
            .font(.callout)
          Text("\(facet.value) (\(facet.count))")
            .fontWeight(isSelected ? .semibold : .regular)
        }
        .padding(.leading, CGFloat(level * 15))
        .onTapGesture {
          hierarchicalController.select(item.facet.value)
        }
      }
    }
  }

  private func maxSelectedLevel(_ hierarchicalFacets: [HierarchicalFacet]) -> Int? {
    return hierarchicalFacets
      .filter { $0.isSelected }
      .max { $0.level < $1.level }?
      .level
  }

  private func facet(from hierarchicalFacet: HierarchicalFacet) -> Facet {
    let value = hierarchicalFacet
      .facet
      .value
      .split(separator: ">")
      .map { $0.trimmingCharacters(in: .whitespaces) }[hierarchicalFacet.level]
    return Facet(value: value, count: hierarchicalFacet.facet.count, highlighted: nil)
  }

  public init(hierarchicalController: HierarchicalObservableController) {
    self.hierarchicalController = hierarchicalController
  }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct HierarchicalListPreview: PreviewProvider {

  static var previews: some View {
    let controller: HierarchicalObservableController = .init()
    HierarchicalList(hierarchicalController: controller)
      .onAppear {
        controller.setItem([
          (Facet(value: "Category1", count: 10), 0, false),
          (Facet(value: "Category1 > Category1-1", count: 7), 1, false),
          (Facet(value: "Category1 > Category1-2", count: 2), 1, false),
          (Facet(value: "Category1 > Category1-3", count: 1), 1, false),
          (Facet(value: "Category2", count: 14), 0, true),
          (Facet(value: "Category2 > Category2-1", count: 8), 1, false),
          (Facet(value: "Category2 > Category2-2", count: 4), 1, true),
          (Facet(value: "Category2 > Category2-2 > Category2-2-1", count: 2), 2, false),
          (Facet(value: "Category2 > Category2-2 > Category2-2-2", count: 2), 2, true),
          (Facet(value: "Category2 > Category2-3", count: 2), 1, false)
        ])
      }
  }

}
#endif

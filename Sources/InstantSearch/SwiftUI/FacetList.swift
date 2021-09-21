//
//  FacetList.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// A view presenting the list of facets
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FacetList<Row: View, NoResults: View>: View {

  @ObservedObject public var facetListObservableController: FacetListObservableController

  /// Closure constructing a facet row view
  public var row: (Facet, Bool) -> Row

  /// Closure constructing a no results view
  public var noResults: (() -> NoResults)?

  public init(_ facetListObservableController: FacetListObservableController,
              @ViewBuilder row: @escaping (Facet, Bool) -> Row,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    self.facetListObservableController = facetListObservableController
    self.row = row
    self.noResults = noResults
  }

  public var body: some View {
    if let noResults = noResults?(), facetListObservableController.facets.isEmpty {
      noResults
    } else {
      VStack {
        ForEach(facetListObservableController.facets, id: \.self) { facet in
          row(facet, facetListObservableController.isSelected(facet))
            .onTapGesture {
              facetListObservableController.toggle(facet)
            }
        }
      }
    }
  }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension FacetList where NoResults == Never {

  init(_ facetListObservableController: FacetListObservableController,
       @ViewBuilder row: @escaping(Facet, Bool) -> Row) {
    self.facetListObservableController = facetListObservableController
    self.row = row
    self.noResults = nil
  }

}

@available(iOS 13.0, OSX 11.00, tvOS 13.0, watchOS 6.0, *)
struct Facets_Previews: PreviewProvider {

  static let test: [Facet] = {
    [
      ("Samsung", 356, "<em>S</em>amsung"),
      ("Sony", 236, "<em>S</em>ony"),
      ("Insignia", 230, nil),
      ("Dynex", 202, nil),
      ("RocketFish", 193, nil),
      ("HP", 192, nil),
      ("Apple", 162, nil),
      ("LG", 141, nil),
      ("Metra", 132, nil),
      ("Microsoft", 121, nil),
      ("Logitech", 119, nil),
      ("ZAGG", 119, nil),
      ("Griffin Technology", 109, nil),
      ("Belkin", 104, nil)
    ].map { value, count, highlighted in
      Facet(value: value, count: count, highlighted: highlighted)
    }
  }()

  static let demoController: FacetListObservableController = {
    let demoController = FacetListObservableController(facets: test, selections: ["Samsung"])
    demoController.onClick = { facet in
      demoController.selections.formSymmetricDifference([facet.value])
    }
    return demoController
  }()

  static var previews: some View {
    NavigationView {
      FacetList(demoController, row: FacetRow.init)
    }
  }

}
#endif

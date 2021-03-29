//
//  FacetList.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
import SwiftUI

#if os(iOS) || os(macOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FacetList<Row: View, NoResults: View>: View {

  @ObservedObject public var facetListObservableController: FacetListObservableController
  public var row: (Facet, Bool) -> Row
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
      ScrollView(showsIndicators: true) {
        VStack() {
          ForEach(facetListObservableController.facets, id: \.self) { facet in
            row(facet, facetListObservableController.isSelected(facet))
              .onTapGesture {
                facetListObservableController.select(facet)
              }
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
public struct FacetRow: View {
  
  public var facet: Facet
  public var isSelected: Bool
  
  public var body: some View {
    HStack(spacing: 0) {
      Text(facet.description)
        .font(.footnote)
        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: .infinity, alignment: .leading)
      if isSelected {
        Image(systemName: "checkmark")
          .font(.footnote)
          .frame(maxHeight: .infinity, alignment: .trailing)
      }
    }
    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    .background(Color(backgroundColor))
  }
  
  #if canImport(UIKit)
  private var backgroundColor: UIColor {
    return .systemBackground
  }
  #elseif canImport(AppKit)
  private var backgroundColor: NSColor {
    return .controlBackgroundColor
  }
  #endif
  
  public init(facet: Facet, isSelected: Bool) {
    self.facet = facet
    self.isSelected = isSelected
  }
  
}


@available(iOS 13.0, OSX 11.00, tvOS 13.0, watchOS 6.0, *)
struct Facets_Previews : PreviewProvider {
  
  static let test: [Facet] = {
    [
      ("Samsung", 356),
      ("Sony", 236),
      ("Insignia", 230),
      ("Dynex", 202),
      ("RocketFish", 193),
      ("HP", 192),
      ("Apple", 162),
      ("LG", 141),
      ("Metra", 132),
      ("Microsoft", 121),
      ("Logitech", 119),
      ("ZAGG", 119),
      ("Griffin Technology", 109),
      ("Belkin", 104),
    ].map { value, count in
      Facet(value: value, count: count)
    }
  }()
    
  static var previews: some View {
    NavigationView {
      let controller = FacetListObservableController(facets: test, selections: ["Samsung"])
      let _ = controller.onClick = { facet in
        controller.selections.formSymmetricDifference([facet.value])
      }
      FacetList(controller, row: FacetRow.init)
    }
  }
  
}
#endif

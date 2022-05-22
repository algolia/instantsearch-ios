//
//  DynamicFacetList.swift
//  Examples
//
//  Created by Vladislav Fitc on 07.04.2022.
//

import Foundation
import InstantSearchSwiftUI
import SwiftUI

struct DynamicFacetList: View {

  @ObservedObject var dynamicFacetListController: DynamicFacetListObservableController

  var body: some View {
    ScrollView {
      ForEach(dynamicFacetListController.orderedFacets, id: \.attribute) { orderedFacet in
        Section(header: header(withTitle: "\(orderedFacet.attribute.rawValue)")) {
          ForEach(orderedFacet.facets, id: \.value) { facet in
            VStack {
              FacetRow(facet: facet,
                       isSelected: dynamicFacetListController.isSelected(facet, for: orderedFacet.attribute))
              .onTapGesture {
                dynamicFacetListController.toggle(facet, for: orderedFacet.attribute)
              }
              .frame(minHeight: 40, idealHeight: 40, maxHeight: .infinity, alignment: .center)
              Divider()
            }
            .padding(.horizontal, 20)
          }
        }
      }
    }
  }

  @ViewBuilder func header(withTitle title: String) -> some View {
    VStack(spacing: 0) {
      Text(title)
        .fontWeight(.medium)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
      Divider()
    }
    .padding(.horizontal, 20)
  }

}

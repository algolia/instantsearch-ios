//
//  DynamicFacetListSwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 16/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct DynamicFacetList: View {
  
  @ObservedObject var dynamicFacetListController: DynamicFacetListObservableController
    
  var body: some View {
    ScrollView {
      ForEach(dynamicFacetListController.orderedFacets, id: \.attribute) { orderedFacet in
        VStack(spacing: 0) {
          // Facet header
          ZStack {
            Color(.systemGray5)
            Text(orderedFacet.attribute.rawValue)
              .fontWeight(.semibold)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 5)
          }
          // Facet values
          ForEach(orderedFacet.facets, id: \.value) { facet in
            VStack(spacing: 0) {
              FacetRow(facet: facet,
                       isSelected: dynamicFacetListController.isSelected(facet, for: orderedFacet.attribute))
                .onTapGesture {
                  dynamicFacetListController.toggle(facet, for: orderedFacet.attribute)
                }
                .frame(minHeight: 44, idealHeight: 44, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 5)
            }
          }
        }
      }
    }
  }
  
}

struct DynamicFacetsDemoView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  var dynamicFacetListController: DynamicFacetListObservableController

  var body: some View {
    NavigationView {
      DynamicFacetList(dynamicFacetListController: dynamicFacetListController)
        .navigationBarTitle("Dynamic facets")
    }
    .searchable(text: $queryInputController.query)
  }
  
}

class DynamicFacetListSwiftUIDemoViewController: UIHostingController<DynamicFacetsDemoView> {
  
  let queryInputController: QueryInputObservableController
  let facetsController: DynamicFacetListObservableController
  let algoliaController: DynamicFacetListDemoController
  
  init() {
    queryInputController = .init()
    facetsController = .init()
    algoliaController = .init(queryInputController: queryInputController,
                              DynamicFacetListController: facetsController)
    super.init(rootView: DynamicFacetsDemoView(queryInputController: queryInputController,
                                               dynamicFacetListController: facetsController))
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

struct DynamicFacetList_Preview: PreviewProvider {
  
  static let queryInputController = QueryInputObservableController()
  static let facetsController = DynamicFacetListObservableController()
  static let controller = DynamicFacetListDemoController(queryInputController: queryInputController,
                                                      DynamicFacetListController: facetsController)
  
  static var previews: some View {
    _ = DynamicFacetList_Preview.controller
    return DynamicFacetsDemoView(queryInputController: DynamicFacetList_Preview.queryInputController,
                                 dynamicFacetListController: DynamicFacetList_Preview.facetsController)
  }
  
}

//
//  FacetSearchDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 07.04.2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

class FacetSearchDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    
    let facetListController: FacetListObservableController
    let queryInputController: QueryInputObservableController
    let filterStateController: FilterStateObservableController
    let demoController: FacetSearchDemoController
    
    init() {
      facetListController = FacetListObservableController()
      queryInputController = QueryInputObservableController()
      demoController = FacetSearchDemoController(facetListController: facetListController,
                                                 queryInputController: queryInputController)
      filterStateController = FilterStateObservableController(filterState: demoController.filterState)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var facetListController: FacetListObservableController
    @ObservedObject var filterStateDebugController: FilterStateObservableController
    
    var body: some View {
      VStack {
        FilterStateDebugView(filterStateDebugController)
          .padding()
        ScrollView {
          FacetList(facetListController) { facet, isSelected in
            FacetRow(facet: facet, isSelected: isSelected)
              .padding()
          }
          .navigationBarTitle("Facet Search")
        }
      }
      .searchable(text: $queryInputController.query)
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(queryInputController: controller.queryInputController,
                facetListController: controller.facetListController,
                filterStateDebugController: controller.filterStateController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Facet Search")
    }
  }
  
}

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
    
    let demoController: FacetSearchDemoController

    let facetListController: FacetListObservableController
    let clearFilterController: FilterClearObservableController
    let queryInputController: QueryInputObservableController
    let filterStateController: FilterStateObservableController
    
    init() {
      facetListController = FacetListObservableController()
      queryInputController = QueryInputObservableController()
      demoController = FacetSearchDemoController()
      filterStateController = FilterStateObservableController(filterState: demoController.filterState)
      clearFilterController = .init()
      demoController.facetListConnector.connectController(facetListController)
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.clearFilterConnector.connectController(clearFilterController)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var facetListController: FacetListObservableController

    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
          .padding()
        ScrollView {
          FacetList(facetListController) { facet, isSelected in
            VStack {
              FacetRow(facet: facet, isSelected: isSelected)
              Divider()
            }
            .padding()
          }
          .navigationBarTitle("Facet Search")
        }
      }
      .searchable(text: $queryInputController.query)
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                queryInputController: controller.queryInputController,
                facetListController: controller.facetListController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Facet Search")
    }
  }
  
}

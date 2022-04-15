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

class FacetSearchDemoSwiftUI: PreviewProvider {
  
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
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      self.controller = Controller()
      super.init(rootView: ContentView(queryInputController: controller.queryInputController,
                                       facetListController: controller.facetListController,
                                       filterStateDebugController: controller.filterStateController))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return NavigationView {
      ContentView(queryInputController: controller.queryInputController,
                  facetListController: controller.facetListController,
                  filterStateDebugController: controller.filterStateController)
    }
  }
  
}

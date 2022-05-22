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
    let searchBoxController: SearchBoxObservableController
    let filterStateController: FilterStateObservableController

    init() {
      facetListController = FacetListObservableController()
      searchBoxController = SearchBoxObservableController()
      demoController = FacetSearchDemoController()
      filterStateController = FilterStateObservableController(filterState: demoController.filterState)
      clearFilterController = .init()
      demoController.facetListConnector.connectController(facetListController)
      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.clearFilterConnector.connectController(clearFilterController)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var searchBoxController: SearchBoxObservableController
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
            .padding(.horizontal, 20)
          }
          .navigationBarTitle("Facet Search")
        }
      }
      .searchable(text: $searchBoxController.query)
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                searchBoxController: controller.searchBoxController,
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

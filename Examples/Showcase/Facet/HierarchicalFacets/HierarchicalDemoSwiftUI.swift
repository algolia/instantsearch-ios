//
//  HierarchicalDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

class HierarchicalDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: HierarchicalDemoController
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController
    let observableController: HierarchicalObservableController

    init() {
      observableController = HierarchicalObservableController()
      demoController = HierarchicalDemoController(controller: observableController)
      filterStateController = .init(filterState: demoController.filterState)
      clearFilterController = .init()
      demoController.clearFilterConnector.connectController(clearFilterController)
    }

  }

  struct ContentView: View {

    let hierarchicalController: HierarchicalObservableController
    let filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        HierarchicalList(hierarchicalController) { facet, nestingLevel, isSelected in
          HierarchicalFacetRow(facet: facet,
                               nestingLevel: nestingLevel,
                               isSelected: isSelected)
          .frame(height: 30)
          Divider()
        }
        Spacer()
      }
      .padding()
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(hierarchicalController: controller.observableController,
                filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Hierarchical Facets")
    }
  }

}

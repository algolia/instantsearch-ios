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
    
    let observableController: HierarchicalObservableController
    let demoController: HierarchicalDemoController
    let filterStateController: FilterStateObservableController
    
    init() {
      observableController = HierarchicalObservableController()
      demoController = HierarchicalDemoController(controller: observableController)
      filterStateController = .init(filterState: demoController.filterState)
    }
    
  }
  
  struct ContentView: View {
    
    let hierarchicalController: HierarchicalObservableController
    let filterStateController: FilterStateObservableController
    
    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController)
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
                filterStateController: controller.filterStateController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Hierarchical Facets")
    }
  }
  
}


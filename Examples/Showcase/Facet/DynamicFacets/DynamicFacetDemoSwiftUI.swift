//
//  DynamicFacetDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 16/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct DynamicFacetDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let searchBoxController: SearchBoxObservableController
    let filterStateController: FilterStateObservableController
    let facetsController: DynamicFacetListObservableController
    let demoController: DynamicFacetListDemoController

    init() {
      searchBoxController = SearchBoxObservableController()
      facetsController = DynamicFacetListObservableController()
      demoController = DynamicFacetListDemoController(searchBoxController: searchBoxController,
                                                      dynamicFacetListController: facetsController)
      filterStateController = FilterStateObservableController(filterState: demoController.filterState)
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(searchBoxController: controller.searchBoxController,
                facetsController: controller.facetsController)
  }

  struct ContentView: View {

    @ObservedObject var searchBoxController: SearchBoxObservableController
    let facetsController: DynamicFacetListObservableController

    @State private var isHelpPresented: Bool = false

    var body: some View {
      DynamicFacetList(dynamicFacetListController: facetsController)
        .alert(isPresented: $isHelpPresented) {
          Alert(title: Text("Help"),
                message: Text(DynamicFacetListDemoController.helpMessage),
                dismissButton: .default(Text("OK")))
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { isHelpPresented = true },
                   label: { Image(systemName: "info.circle.fill") })
          }
        }
        .searchable(text: $searchBoxController.query)
    }

  }

  static let controller = Controller()
  static var previews: some View {
    return NavigationView {
      NavigationView {
        ContentView(searchBoxController: controller.searchBoxController,
                    facetsController: controller.facetsController)
        .navigationBarTitle("Dynamic facets")
      }
    }
  }

}

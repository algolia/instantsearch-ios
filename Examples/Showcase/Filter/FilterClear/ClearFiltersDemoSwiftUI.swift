//
//  ClearFiltersDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ClearFiltersDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: ClearFiltersDemoController
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController
    let clearFilterGroupController: FilterClearObservableController
    let clearExceptFilterGroupController: FilterClearObservableController

    init() {
      clearFilterController = .init()
      clearFilterGroupController = .init()
      clearExceptFilterGroupController = .init()
      demoController = ClearFiltersDemoController()
      filterStateController = .init(filterState: demoController.filterState)
      demoController.clearConnector.connectController(clearFilterController)
      demoController.clearGroupConnector.connectController(clearFilterGroupController)
      demoController.clearExceptGroupConnector.connectController(clearExceptFilterGroupController)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var clearFilterGroupController: FilterClearObservableController
    @ObservedObject var clearExceptFilterGroupController: FilterClearObservableController

    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        HStack {
          Button("Clear Colors") {
            clearFilterGroupController.clear()
          }.padding().overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
          Spacer()
          Button("Clear except Colors") {
            clearExceptFilterGroupController.clear()
          }.padding().overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
        }
        Spacer()
      }.padding()

    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                clearFilterGroupController: controller.clearFilterGroupController,
                clearExceptFilterGroupController: controller.clearExceptFilterGroupController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Filter Clear")
    }
  }

}

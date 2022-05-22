//
//  CurrentFiltersDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct CurrentFiltersDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: CurrentFiltersDemoController
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController
    let currentFiltersController: CurrentFiltersObservableController

    init() {
      demoController = .init()
      currentFiltersController = .init()
      clearFilterController = .init()
      filterStateController = .init(filterState: demoController.filterState)
      demoController.currentFiltersListConnector.connectController(currentFiltersController)
      demoController.clearFiltersConnector.connectController(clearFilterController)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var currentFiltersController: CurrentFiltersObservableController

    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        let filtersPerGroup = Dictionary(grouping: currentFiltersController.filters) { $0.id }
          .mapValues { $0.map(\.filter) }
          .map { $0 }
        ForEach(filtersPerGroup, id: \.key) { (group, filters) in
          HStack {
            Text(group.description)
              .bold()
              .padding(.leading)
            Spacer()
          }
          .padding(.vertical, 5)
          .background(Color(.systemGray5))
          ForEach(filters, id: \.self) { filter in
            HStack {
              Text(filter.description)
              Spacer()
              Button {
                currentFiltersController.remove(FilterAndID(filter: filter, id: group))
              } label: {
                Image(systemName: "xmark.circle")
              }
            }.padding()
          }
        }
        Spacer()
      }
      .padding()
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                currentFiltersController: controller.currentFiltersController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Current Filter")
    }
  }

}

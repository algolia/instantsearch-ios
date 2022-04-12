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

struct CurrentFiltersDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let demoController: CurrentFiltersDemoController
    let filterStateController: FilterStateObservableController
    let currentFiltersController: CurrentFiltersObservableController
    
    init() {
      demoController = .init()
      currentFiltersController = .init()
      filterStateController = .init(filterState: demoController.filterState)
      demoController.currentFiltersListConnector.connectController(currentFiltersController)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var currentFiltersController: CurrentFiltersObservableController
    
    var body: some View {
      NavigationView {
        VStack {
          FilterStateDebugView(filterStateController)
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
        .navigationBarTitle("Current Filter")
      }
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      self.controller = Controller()
      let rootView = ContentView(filterStateController: controller.filterStateController,
                                 currentFiltersController: controller.currentFiltersController)
      super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(filterStateController: controller.filterStateController,
                       currentFiltersController: controller.currentFiltersController)
  }
  
}

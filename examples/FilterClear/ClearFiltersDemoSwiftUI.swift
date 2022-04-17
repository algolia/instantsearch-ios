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
    let filterClearController: FilterClearObservableController
    let filterClearExceptController: FilterClearObservableController
    
    init() {
      filterClearController = .init()
      filterClearExceptController = .init()
      demoController = ClearFiltersDemoController(clearController: filterClearController,
                                                  clearExceptController: filterClearExceptController)
      filterStateController = .init(filterState: demoController.filterState)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var filterClearController: FilterClearObservableController
    @ObservedObject var filterClearExceptController: FilterClearObservableController
    
    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController)
        HStack {
          Button("Clear Colors") {
            filterClearController.clear()
          }.padding().overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
          Spacer()
          Button("Clear except Colors") {
            filterClearExceptController.clear()
          }.padding().overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
        }
        Spacer()
      }.padding()
      
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                filterClearController: controller.filterClearController,
                filterClearExceptController: controller.filterClearExceptController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Filter Clear")
    }
  }
  
}

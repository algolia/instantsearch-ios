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

struct ClearFiltersDemoSwiftUI: PreviewProvider {
  
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
      NavigationView {
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
        .navigationBarTitle("Filter Clear")
      }
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      controller = .init()
      let contentView = ContentView(filterStateController: controller.filterStateController,
                                    filterClearController: controller.filterClearController,
                                    filterClearExceptController: controller.filterClearExceptController)
      super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(filterStateController: controller.filterStateController, filterClearController: controller.filterClearController, filterClearExceptController: controller.filterClearExceptController)
  }
  
}

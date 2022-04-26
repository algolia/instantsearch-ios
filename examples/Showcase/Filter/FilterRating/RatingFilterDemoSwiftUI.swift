//
//  RatingFilterDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchSwiftUI

struct RatingFilterDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    
    let demoController: RatingFilterDemoController
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController
    
    init() {
      demoController = .init()
      filterStateController = .init(filterState: demoController.filterState)
      clearFilterController = .init()
      demoController.clearFilterConnector.connectController(clearFilterController)
    }
    
  }
  
  struct ContentView: View {
    
    @State var value: Double = 3.5
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController
    
    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        Stepper(value: $value, in: 0...5, step: 0.1) {
          HStack {
            RatingView(value: $value)
              .frame(height: 40, alignment: .center)
            Text(String(format: "%.1f", value))
          }
        }
        .padding()
        Spacer()
      }
      .padding()
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Filter Rating")
    }
  }
  
}

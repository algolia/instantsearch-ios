//
//  RatingFilterDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchSwiftUI

struct RatingFilterDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let demoController: RatingFilterDemoController
    let filterStateController: FilterStateObservableController

    init() {
      self.demoController = .init()
      self.filterStateController = .init(filterState: demoController.filterState)
    }
    
  }
    
  struct ContentView: View {
        
    @State var value: Double = 3.5
    @ObservedObject var filterStateController: FilterStateObservableController

    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController)
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
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      self.controller = .init()
      let contentView = ContentView(filterStateController: controller.filterStateController)
      super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(filterStateController: controller.filterStateController)
  }
    
}

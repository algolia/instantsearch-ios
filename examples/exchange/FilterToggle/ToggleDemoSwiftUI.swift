//
//  ToggleDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 01/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI


struct ToggleDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let demoController: ToggleDemoController
    let tagFilterFilterObservableController: FilterToggleObservableController<Filter.Tag>
    let facetFilterFilterObservableController: FilterToggleObservableController<Filter.Facet>
    let numericFilterFilterObservableController: FilterToggleObservableController<Filter.Numeric>
    let filterStateController: FilterStateObservableController
    
    init() {
      self.tagFilterFilterObservableController = .init()
      self.facetFilterFilterObservableController = .init()
      self.numericFilterFilterObservableController = .init()
      self.demoController = .init()
      self.filterStateController = .init(filterState: demoController.filterState)
      demoController.sizeConstraintConnector.connectController(numericFilterFilterObservableController)
      demoController.couponConnector.connectController(facetFilterFilterObservableController)
      demoController.vintageConnector.connectController(tagFilterFilterObservableController)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var tagFilterFilterObservableController: FilterToggleObservableController<Filter.Tag>
    @ObservedObject var facetFilterFilterObservableController: FilterToggleObservableController<Filter.Facet>
    @ObservedObject var numericFilterFilterObservableController: FilterToggleObservableController<Filter.Numeric>
    
    var body: some View {
      VStack(spacing: 20) {
        FilterStateDebugView(filterStateController)
        HStack() {
          if let numericFilter = numericFilterFilterObservableController.filter {
            Toggle(numericFilter.description, isOn: $numericFilterFilterObservableController.isSelected)
              .toggleStyle(.button)
          }
          if let tagFilter = tagFilterFilterObservableController.filter {
            Toggle(tagFilter.description, isOn: $tagFilterFilterObservableController.isSelected)
              .toggleStyle(CheckboxToggleStyle())
          }
          if let _ = facetFilterFilterObservableController.filter {
            Toggle("Coupon", isOn: $facetFilterFilterObservableController.isSelected)
          }
        }
        Spacer()
      }.padding()
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let demoController: Controller
    
    init() {
      self.demoController = .init()
      let contentView = ContentView(filterStateController: demoController.filterStateController,
                                    tagFilterFilterObservableController: demoController.tagFilterFilterObservableController,
                                    facetFilterFilterObservableController: demoController.facetFilterFilterObservableController,
                                    numericFilterFilterObservableController: demoController.numericFilterFilterObservableController)
      super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(filterStateController: controller.filterStateController,
                       tagFilterFilterObservableController: controller.tagFilterFilterObservableController,
                       facetFilterFilterObservableController: controller.facetFilterFilterObservableController,
                       numericFilterFilterObservableController: controller.numericFilterFilterObservableController)
  }
  
}

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: ToggleStyleConfiguration) -> some View {
    return HStack(spacing: 7) {
      configuration.label
      Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        .resizable()
        .frame(width: 22, height: 22)
        .onTapGesture { configuration.isOn.toggle() }
    }.onTapGesture {
      configuration.isOn = !configuration.isOn
    }
  }
}

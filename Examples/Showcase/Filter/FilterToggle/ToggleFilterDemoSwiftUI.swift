//
//  ToggleFilterDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 01/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ToggleFilterDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: ToggleFilterDemoController

    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController

    let tagFilterFilterObservableController: FilterToggleObservableController<Filter.Tag>
    let facetFilterFilterObservableController: FilterToggleObservableController<Filter.Facet>
    let numericFilterFilterObservableController: FilterToggleObservableController<Filter.Numeric>

    init() {
      self.tagFilterFilterObservableController = .init()
      self.facetFilterFilterObservableController = .init()
      self.numericFilterFilterObservableController = .init()
      self.demoController = .init()
      self.filterStateController = .init(filterState: demoController.filterState)
      self.clearFilterController = .init()
      demoController.clearFilterConnector.connectController(clearFilterController)
      demoController.sizeConstraintConnector.connectController(numericFilterFilterObservableController)
      demoController.couponConnector.connectController(facetFilterFilterObservableController)
      demoController.vintageConnector.connectController(tagFilterFilterObservableController)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var tagFilterFilterObservableController: FilterToggleObservableController<Filter.Tag>
    @ObservedObject var facetFilterFilterObservableController: FilterToggleObservableController<Filter.Facet>
    @ObservedObject var numericFilterFilterObservableController: FilterToggleObservableController<Filter.Numeric>

    var body: some View {
      VStack(spacing: 20) {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        HStack {
          if let numericFilter = numericFilterFilterObservableController.filter {
            Toggle(numericFilter.description, isOn: $numericFilterFilterObservableController.isSelected)
              .toggleStyle(.button)
          }
          if let tagFilter = tagFilterFilterObservableController.filter {
            Toggle(tagFilter.description, isOn: $tagFilterFilterObservableController.isSelected)
              .toggleStyle(CheckboxToggleStyle())
          }
          if facetFilterFilterObservableController.filter != nil {
            Toggle("Coupon", isOn: $facetFilterFilterObservableController.isSelected)
          }
        }
        Spacer()
      }.padding()
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                tagFilterFilterObservableController: controller.tagFilterFilterObservableController,
                facetFilterFilterObservableController: controller.facetFilterFilterObservableController,
                numericFilterFilterObservableController: controller.numericFilterFilterObservableController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Filter Toggle")
    }
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

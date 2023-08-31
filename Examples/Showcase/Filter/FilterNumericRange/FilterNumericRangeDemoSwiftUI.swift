//
//  FilterNumericRangeDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI
import Sliders

struct FilterNumericRangeDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  class Controller {
    let demoController = FilterNumericRangeDemoController()
    let numberRangeController = NumberRangeObservableController<Double>(range: 0...5,
                                                                        bounds: 0...5)
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController

    init() {
      filterStateController = .init(filterState: demoController.filterState)
      clearFilterController = .init()
      demoController.rangeConnector.connectController(numberRangeController)
      demoController.filterClearConnector.connectController(clearFilterController)
    }
  }

  struct ContentView: View {
    @ObservedObject var slider = CustomSlider(bounds: 0.0...5, values: 0...5)
    @ObservedObject var numberRangeController: NumberRangeObservableController<Double>
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    var body: some View {
      VStack(spacing: 40) {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        .frame(height: 200)
        HStack(spacing: 20) {
          Text("\(Int(numberRangeController.bounds.lowerBound))")
          Sliders.RangeSlider(range: $numberRangeController.range, in: numberRangeController.bounds, step: 1)
          Text("\(Int(numberRangeController.bounds.upperBound))")
        }
        Spacer()
      }.padding()
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(numberRangeController: controller.numberRangeController,
                filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Number Range Filter")
    }
  }
}

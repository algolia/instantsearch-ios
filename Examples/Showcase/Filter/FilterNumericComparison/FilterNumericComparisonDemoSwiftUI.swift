//
//  FilterNumericComparisonDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 16/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct FilterNumericComparisonDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: FilterNumericComparisonDemoController
    let clearFilterController: FilterClearObservableController
    let yearController: NumberObservableController<Int>
    let priceController: NumberObservableController<Double>
    let filterStateController: FilterStateObservableController

    init() {
      demoController = .init()
      yearController = .init()
      priceController = .init()
      clearFilterController = .init()
      demoController.yearConnector.connectNumberController(yearController)
      demoController.priceConnector.connectNumberController(priceController)
      demoController.clearFilterConnector.connectController(clearFilterController)
      filterStateController = .init(filterState: demoController.filterState)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var priceController: NumberObservableController<Double>
    @ObservedObject var yearController: NumberObservableController<Int>

    @State private var yearValue: String = ""

    var body: some View {
      return VStack(spacing: 40) {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        HStack {
          Text("Year")
          Spacer()
          TextField("Year", text: $yearValue)
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: 80)
            .multilineTextAlignment(.trailing)
            .onSubmit {
              if let year = Int(yearValue) {
                yearController.value = year
              }
            }
        }
        HStack {
          Stepper(value: $priceController.value,
                  in: priceController.bounds,
                  step: 0.1) {
            HStack {
              Text("Price:")
              Spacer()
              Text(String(format: "%.2f", priceController.value))
            }
          }
        }
        Spacer()
      }
      .padding()
      .onAppear {
        yearValue = "\(yearController.value)"
      }
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    return ContentView(filterStateController: controller.filterStateController,
                       clearFilterController: controller.clearFilterController,
                       priceController: controller.priceController,
                       yearController: controller.yearController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Filter Numeric Comparison")
    }
  }

}

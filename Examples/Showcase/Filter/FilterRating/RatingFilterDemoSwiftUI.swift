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
    let ratingController: NumberObservableController<Double>
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController

    init() {
      demoController = .init()
      ratingController = .init(value: 3.5)
      filterStateController = .init(filterState: demoController.filterState)
      clearFilterController = .init()
      demoController.clearFilterConnector.connectController(clearFilterController)
      demoController.numberInteractor.connectNumberController(ratingController)
    }

  }

  struct ContentView: View {

    @State var value: Double = 3.5
    @ObservedObject var ratingController: NumberObservableController<Double>
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    var body: some View {
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
        Stepper(value: $ratingController.value, in: 0...5, step: 0.1) {
          HStack {
            RatingView(value: $ratingController.value)
              .frame(height: 40, alignment: .center)
            Text(String(format: "%.1f", ratingController.value))
          }
        }
        .padding()
        Spacer()
      }
      .padding()
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(ratingController: controller.ratingController,
                filterStateController: controller.filterStateController,
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

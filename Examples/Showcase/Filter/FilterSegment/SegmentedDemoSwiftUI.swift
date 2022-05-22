//
//  SegmentedDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 07.04.2022.
//

import Foundation
import UIKit
import SwiftUI
import InstantSearch
import InstantSearchSwiftUI

class SegmentedDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: SegmentedFilterDemoController
    let selectableSegmentController: SelectableSegmentObservableController
    let filterStateController: FilterStateObservableController
    let clearFilterController: FilterClearObservableController

    init() {
      selectableSegmentController = SelectableSegmentObservableController()
      demoController = SegmentedFilterDemoController()
      filterStateController = FilterStateObservableController(filterState: demoController.filterState)
      clearFilterController = FilterClearObservableController()
      demoController.filterMapConnector.connectController(selectableSegmentController)
      demoController.clearFilterConnector.connectController(clearFilterController)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var selectableSegmentController: SelectableSegmentObservableController

    @State private var selected = 0

    var body: some View {
      let selectedBinding = Binding(
        get: { self.selectableSegmentController.selectedSegmentIndex ?? 0 },
        set: { self.selectableSegmentController.select($0) }
      )
      VStack {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
          .padding()
        Picker("Filter Segment", selection: selectedBinding) {
          ForEach(0 ..< selectableSegmentController.segmentsTitles.count, id: \.self) { index in
            let title = selectableSegmentController.segmentsTitles[index]
            Button(title) {
              selectableSegmentController.select(index)
            }
          }
        }
        .pickerStyle(.segmented)
        .padding()
        Spacer()
      }
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                selectableSegmentController: controller.selectableSegmentController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Filter Segment")
    }
  }

}

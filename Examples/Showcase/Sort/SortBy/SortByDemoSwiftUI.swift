//
//  SortByDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct SortByDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: SortByDemoController
    let searchBoxController: SearchBoxObservableController
    let selectableSegmentObservableController: SelectableSegmentObservableController
    let hitsController: HitsObservableController<Hit<StoreItem>>

    init() {
      demoController = SortByDemoController()
      searchBoxController = SearchBoxObservableController()
      selectableSegmentObservableController = SelectableSegmentObservableController()
      hitsController = HitsObservableController<Hit<StoreItem>>()

      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.hitsConnector.connectController(hitsController)
      demoController.sortByConnector.connectController(selectableSegmentObservableController,
                                                       presenter: demoController.title(for:))
    }

  }

  struct ContentView: View {

    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var selectableSegmentObservableController: SelectableSegmentObservableController
    @ObservedObject var hitsController: HitsObservableController<Hit<StoreItem>>

    var body: some View {
      let selectedBinding = Binding(
        get: { self.selectableSegmentObservableController.selectedSegmentIndex ?? 0 },
        set: { self.selectableSegmentObservableController.select($0) }
      )
      VStack {
        Picker("Filter Segment", selection: selectedBinding) {
          ForEach(0 ..< selectableSegmentObservableController.segmentsTitles.count, id: \.self) { index in
            let title = selectableSegmentObservableController.segmentsTitles[index]
            Button(title) {
              selectableSegmentObservableController.select(index)
            }
          }
        }
        .pickerStyle(.segmented)
        HitsList(hitsController) { hit, _ in
          ProductRow(storeItemHit: hit!)
            .padding()
            .frame(height: 100)
          Divider()
        }
      }
      .padding(.horizontal, 16)
      .searchable(text: $searchBoxController.query)
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(searchBoxController: controller.searchBoxController,
                selectableSegmentObservableController: controller.selectableSegmentObservableController,
                hitsController: controller.hitsController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Sort By")
    }

  }

}

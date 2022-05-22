//
//  StatsDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct StatsDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: StatsDemoController
    let searchBoxController: SearchBoxObservableController
    let statsController: StatsTextObservableController

    init() {
      searchBoxController = .init()
      demoController = .init()
      statsController = .init()
      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.statsConnector.interactor.connectController(statsController) { stats -> String? in
        guard let stats = stats else {
          return nil
        }
        return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
      }
    }

  }

  struct ContentView: View {

    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var statsController: StatsTextObservableController

    var body: some View {
      VStack {
        Text(statsController.stats)
          .padding()
        Text(statsController.stats)
          .padding()
          .font(Font(UIFont(name: "Chalkduster", size: 15)! as CTFont))
        Spacer()
      }
      .searchable(text: $searchBoxController.query)
    }

  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(searchBoxController: controller.searchBoxController,
                statsController: controller.statsController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Stats")
    }
  }
}

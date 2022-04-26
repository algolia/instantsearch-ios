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
    let queryInputController: QueryInputObservableController
    let statsController: StatsTextObservableController
    
    init() {
      queryInputController = .init()
      demoController = .init()
      statsController = .init()
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.statsConnector.interactor.connectController(statsController) { stats -> String? in
        guard let stats = stats else {
          return nil
        }
        return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
      }
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var statsController: StatsTextObservableController
    
    var body: some View {
      VStack() {
        Text(statsController.stats)
          .padding()
        Text(statsController.stats)
          .padding()
          .font(Font(UIFont(name: "Chalkduster", size: 15)! as CTFont))
        Spacer()
      }
      .searchable(text: $queryInputController.query)
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(queryInputController: controller.queryInputController,
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


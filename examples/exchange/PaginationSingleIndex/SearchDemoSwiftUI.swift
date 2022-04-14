//
//  SearchDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct SearchDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let demoController: SearchDemoController
    let hitsController: HitsObservableController<Hit<StoreItem>>
    let queryInputController: QueryInputObservableController
    let statsController: StatsTextObservableController
    let loadingController: LoadingObservableController

    init() {
      demoController = SearchDemoController()
      hitsController = HitsObservableController()
      queryInputController = QueryInputObservableController()
      statsController = StatsTextObservableController()
      loadingController = LoadingObservableController()
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.hitsInteractor.connectController(hitsController)
      demoController.statsConnector.connectController(statsController)
      demoController.loadingConnector.connectController(loadingController)
      demoController.searcher.search()
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      self.controller = Controller()
      let rootView = ContentView(queryInputController: controller.queryInputController,
                                 hitsController: controller.hitsController,
                                 statsController: controller.statsController,
                                 loadingController: controller.loadingController)
      super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var hitsController: HitsObservableController<Hit<StoreItem>>
    @ObservedObject var statsController: StatsTextObservableController
    @ObservedObject var loadingController: LoadingObservableController
    
    var body: some View {
      VStack {
        HStack {
          Text(statsController.stats)
          Spacer()
          if loadingController.isLoading {
            ProgressView()
          }
        }
        .padding(.horizontal, 20)
        HitsList(hitsController) { (hit, index) in
          ShopItemRow(product: hit)
        } noResults: {
          Text("No Results")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .searchable(text: $queryInputController.query)
      .onSubmit(of: .search) {
        queryInputController.submit()
      }
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return NavigationView {
      ContentView(queryInputController: controller.queryInputController,
                         hitsController: controller.hitsController,
                         statsController: controller.statsController,
                         loadingController: controller.loadingController)
    }
  }
  
}

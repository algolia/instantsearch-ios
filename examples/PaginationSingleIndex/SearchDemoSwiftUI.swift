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

struct SearchDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    
    let demoController: SearchDemoController
    let hitsController: HitsObservableController<Hit<StoreItem>>
    let queryInputController: QueryInputObservableController
    let statsController: StatsTextObservableController
    let loadingController: LoadingObservableController
    
    init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
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
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(queryInputController: controller.queryInputController,
                hitsController: controller.hitsController,
                statsController: controller.statsController,
                loadingController: controller.loadingController)
  }
  
  static func viewController(searchTriggeringMode: SearchTriggeringMode) -> UIViewController {
    let controller = Controller(searchTriggeringMode: searchTriggeringMode)
    let contentView = contentView(with: controller)
    return CommonSwiftUIDemoViewController(controller: controller,
                                           rootView: contentView)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
    }
  }
  
}

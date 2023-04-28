//
//  SearchDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct SearchDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  class Controller {
    let demoController: EcommerceDemoController
    let hitsController: HitsObservableController<Hit<StoreItem>>
    let searchBoxController: SearchBoxObservableController
    let statsController: StatsTextObservableController
    let loadingController: LoadingObservableController
    
    init(searchTriggeringMode: SearchTriggeringMode) {
      demoController = EcommerceDemoController(searchTriggeringMode: searchTriggeringMode)
      hitsController = HitsObservableController()
      searchBoxController = SearchBoxObservableController()
      statsController = StatsTextObservableController()
      loadingController = LoadingObservableController()
      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.hitsInteractor.connectController(hitsController)
      demoController.statsConnector.connectController(statsController)
      demoController.loadingConnector.connectController(loadingController)
      demoController.searcher.search()
    }
  }
  
  struct ContentView: View {
    @StateObject var hitsViewModel: InfiniteScrollViewModel<AlgoliaHitsPage<Hit<StoreItem>>>
    @ObservedObject var searchBoxController: SearchBoxObservableController
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
        .padding(.trailing, 20)
        HitsList(hitsViewModel) { hit in
          ProductRow(storeItemHit: hit)
            .padding()
            .frame(height: 100)
        } noResults: {
          Text("No Results")
        }
      }
      .searchable(text: $searchBoxController.query)
      .onSubmit(of: .search) {
        searchBoxController.submit()
      }
      .padding(.horizontal, 15)
    }
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    let hitsViewModel = controller.demoController.searcher.hitsViewModel(of: Hit<StoreItem>.self)
    return ContentView(hitsViewModel: hitsViewModel,
                       searchBoxController: controller.searchBoxController,
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
  
  static let controller = Controller(searchTriggeringMode: .searchAsYouType)
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
    }
  }
}

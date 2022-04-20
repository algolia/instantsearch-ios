//
//  ContentView.swift
//  SearchWatch WatchKit Extension
//
//  Created by Vladislav Fitc on 18/04/2022.
//

import SwiftUI
import InstantSearchSwiftUI
import InstantSearchCore

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
  
  var body: some View {
    NavigationView {
      HitsList(hitsController) { (hit, index) in
        ProductRow(storeItemHit: hit!, configuration: .watch)
          .frame(height: 50)
          .padding(.vertical, 3)
          .frame(height: 80)
        Divider()
      } noResults: {
        Text("No Results")
      }
    }
    .searchable(text: $queryInputController.query)
  }
  
  @ViewBuilder func image(for hit: Hit<StoreItem>?) -> some View {
    AsyncImage(url: hit!.object.images.first!,
               content: { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                  ProgressView()
              })
  }
  
}


struct ContentView_Previews: PreviewProvider {
  
  static let controller = Controller()
  
  static var previews: some View {
      ContentView(queryInputController: controller.queryInputController,
                  hitsController: controller.hitsController)
      .navigationBarTitle("Algolia")

  }
  
}

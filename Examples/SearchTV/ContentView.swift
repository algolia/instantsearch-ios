//
//  ContentView.swift
//  SearchTV
//
//  Created by Vladislav Fitc on 18/04/2022.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

class Controller {
  
  let demoController: MovieDemoController
  let hitsController: HitsObservableController<Hit<Movie>>
  let queryInputController: QueryInputObservableController
  let statsController: StatsTextObservableController
  let loadingController: LoadingObservableController
  
  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = MovieDemoController()
    hitsController = HitsObservableController()
    queryInputController = QueryInputObservableController()
    statsController = StatsTextObservableController()
    loadingController = LoadingObservableController()
    demoController.queryInputConnector.connectController(queryInputController)
    demoController.hitsInteractor.connectController(hitsController)
    demoController.searcher.search()
  }
  
}

struct ContentView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<Movie>>
  
  var body: some View {
    NavigationView {
      HitsList(hitsController) { hit, _ in
        MovieRow(movieHit: hit!)
          .padding(.bottom, 10)
          .focusable(true)
        Divider()
      } noResults: {
        Text("No Results")
      }
    }
    .searchable(text: $queryInputController.query)
  }
  
}


struct ContentView_Previews: PreviewProvider {
  
  static let controller = Controller()
  static var previews: some View {
    ContentView(queryInputController: controller.queryInputController,
                hitsController: controller.hitsController)
  }
}

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
  
  let demoController: MovieDemoController
  let hitsController: HitsObservableController<Hit<Movie>>
  let queryInputController: QueryInputObservableController
  
  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = MovieDemoController()
    hitsController = HitsObservableController()
    queryInputController = QueryInputObservableController()
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
          .frame(height: 80)
          .padding(.vertical, 3)
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
    .navigationBarTitle("Algolia")
    
  }
  
}

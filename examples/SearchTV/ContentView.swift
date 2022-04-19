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
          HStack(alignment: .top, spacing: 30) {
            image(for: hit)
              .frame(maxWidth: 200)
              .cornerRadius(10)
            Text(hit?.object.name ?? "")
              .multilineTextAlignment(.leading)
              .font(.footnote)
              .lineLimit(2)
              .padding(.vertical, 10)
            Spacer()
          }
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
    .cornerRadius(10)
  }
    
}

struct ContentView_Previews: PreviewProvider {
  
    static let controller = Controller()
    static var previews: some View {
      ContentView(queryInputController: controller.queryInputController,
                  hitsController: controller.hitsController)
    }
}

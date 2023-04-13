//
//  PetSmart.swift
//  PaginationSingleIndex
//
//  Created by Vladislav Fitc on 03/04/2023.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import InstantSearch
import SwiftUI

struct PetSmartItem: Codable {
  
  let name: String
  let images: Images
  
  struct Images: Codable {
    let large: String
    let small: String
  }
  
}

class PetSmartDemoController {
  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<PetSmartItem>>
  let searchBoxConnector: SearchBoxConnector
  let statsConnector: StatsConnector

  init() {
    searcher = .init(client: SearchClient(appID: "",
                                          apiKey: ""),
                     indexName: "p-development-US__products___")
    hitsInteractor = .init(infiniteScrolling: .on(withOffset: 48))
    hitsInteractor.pageCleanUpOffset = 4
    searchBoxConnector = .init(searcher: searcher, searchTriggeringMode: .searchAsYouType)
    statsConnector = .init(searcher: searcher)
    hitsInteractor.connectSearcher(searcher)
  }
}

struct PetSmartDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    let demoController: PetSmartDemoController
    let hitsController: HitsObservableController<Hit<PetSmartItem>>
    let searchBoxController: SearchBoxObservableController
    let statsController: StatsTextObservableController
    let loadingController: LoadingObservableController

    init() {
      demoController = PetSmartDemoController()
      hitsController = HitsObservableController()
      searchBoxController = SearchBoxObservableController()
      statsController = StatsTextObservableController()
      loadingController = LoadingObservableController()
      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.hitsInteractor.connectController(hitsController)
      demoController.statsConnector.connectController(statsController)
      demoController.searcher.search()
    }
  }
  
  struct HitRow: View {
    
    let title: String
    let imageURL: URL?

    var body: some View {
      VStack {
        HStack(alignment: .top, spacing: 20) {
          AsyncImage(url: imageURL,
                     content: { image in
                       image
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                     },
                     placeholder: {
                       if imageURL != nil {
                         ProgressView()
                       } else {
                         Image(systemName: "photo")
                       }
                     })
                     .cornerRadius(10)
                     .scaledToFit()
                     .frame(maxWidth: 60,
                            alignment: .center)
          VStack(alignment: .leading, spacing: 5) {
            Text(title)
              .font(.system(.headline))
          }.multilineTextAlignment(.leading)
          Spacer()
        }
        Spacer()
      }
    }

    init(title: String,
         imageURL: URL) {
      self.title = title
      self.imageURL = imageURL
    }
  }


  struct ContentView: View {
    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var hitsController: HitsObservableController<Hit<PetSmartItem>>
    @ObservedObject var statsController: StatsTextObservableController

    var body: some View {
      VStack {
        HStack {
          Text(statsController.stats)
        }
        .padding(.horizontal, 20)
        HitsList(hitsController) { hit, _ in
          if let hit {
            HitRow(title: hit.object.name,
                        imageURL: URL(string: hit.object.images.large)!)
            .frame(height: 80)
          } else {
            ProgressView()
              .padding()
              .frame(height: 80)
          }
          Divider()
        } noResults: {
          Text("No Results")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .searchable(text: $searchBoxController.query)
      .onSubmit(of: .search) {
        searchBoxController.submit()
      }
      .navigationTitle("PetSmart")
      .padding(.leading, 20)
    }
  }

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(searchBoxController: controller.searchBoxController,
                hitsController: controller.hitsController,
                statsController: controller.statsController)
  }

  static func viewController() -> UIViewController {
    let controller = Controller()
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

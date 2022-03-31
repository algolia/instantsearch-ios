//
//  GettingStartedSwiftUI_iOS15.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 01/10/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

enum GettingStartedSwiftUI_iOS15 {
  
  struct Product: Codable {
    let name: String
    let image: URL?
  }
  
  class AlgoliaController {
    
    let searcher: SingleIndexSearcher
    let suggestionsSearcher: SingleIndexSearcher
    let queryInputInteractor: QueryInputInteractor
    let hitsInteractor: HitsInteractor<Product>
    let suggestionsHitsInteractor: HitsInteractor<QuerySuggestion>
    let statsInteractor: StatsInteractor
    
    let filterState: FilterState
    let facetListInteractor: FacetListInteractor

    init() {
      self.searcher = SingleIndexSearcher(appID: "latency",
                                          apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                          indexName: "instant_search")
      suggestionsSearcher = .init(appID: "latency",
                                  apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                  indexName: "instantsearch_query_suggestions")
      self.queryInputInteractor = .init()
      self.hitsInteractor = .init()
      self.suggestionsHitsInteractor = .init(infiniteScrolling: .off,
                                             showItemsOnEmptyQuery: true)
      self.statsInteractor = .init()
      self.filterState = .init()
      self.facetListInteractor = .init()
      
      setupConnections()
    }
    
    func setupConnections() {
      queryInputInteractor.connectSearcher(searcher)
      queryInputInteractor.connectSearcher(suggestionsSearcher)
      searcher.connectFilterState(filterState)
      hitsInteractor.connectSearcher(searcher)
      suggestionsHitsInteractor.connectSearcher(suggestionsSearcher)
      statsInteractor.connectSearcher(searcher)
      facetListInteractor.connectSearcher(searcher, with: "brand")
      facetListInteractor.connectFilterState(filterState, with: "brand", operator: .or)
    }
        
  }
  
  @available(iOS 15.0, *)
  struct ContentView: View {
        
    @ObservedObject var queryInputConntroller: QueryInputObservableController = .init()
    @ObservedObject var hitsController: HitsObservableController<Product> = .init()
    @ObservedObject var suggestionsController: HitsObservableController<QuerySuggestion> = .init()
    @ObservedObject var statsController: StatsTextObservableController = .init()
    @ObservedObject var facetsController: FacetListObservableController = .init()

    @State private var isPresentingFacets = false
    
    private func text(for suggestion: QuerySuggestion) -> Text {
      if let highlightedValue = suggestion.highlighted {
        let highlightedValueString = HighlightedString(string: highlightedValue)
        return Text(highlightedString: highlightedValueString) { Text($0).bold() }
      } else {
        return Text(suggestion.query)
      }
    }
    
    private func cell(for hit: Product?) -> some View {
      VStack(alignment: .leading, spacing: 10) {
        HStack(alignment: .top) {
          AsyncImage(
            url: hit?.image,
            content: { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
            },
            placeholder: {
              ProgressView()
            })
            .frame(width: 100,
                   height: 100)
            .padding()
          Text(hit?.name ?? "")
            .padding()
        }
        Divider()
      }
    }
    
    var body: some View {
      VStack(spacing: 7) {
        Text(statsController.stats)
          .fontWeight(.medium)
        HitsList(hitsController) { (hit, _) in
          cell(for: hit)
        } noResults: {
          Text("No Results")
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
        }
      }
      .navigationBarTitle("Algolia & SwiftUI")
      .searchable(text: $queryInputConntroller.query,
                  suggestions: suggestionsView)
      .navigationBarItems(trailing: facetsButton())
      .sheet(isPresented: $isPresentingFacets,
             content: facetsView)
    }
    
    @ViewBuilder
    private func suggestionsView() -> some View {
      if !suggestionsController.hits.isEmpty {
        ForEach(suggestionsController.hits.compactMap { $0 }, id: \.query) { suggestion in
          HStack {
            Image(systemName: "magnifyingglass")
            text(for: suggestion)
          }
          .searchCompletion(suggestion.query)
        }
      }
    }
    
    @ViewBuilder
    private func facetsView() -> some View {
      VStack {
        Text("Brand")
          .font(.title)
          .bold()
          .frame(maxWidth: .infinity, alignment: .leading)
        ScrollView {
          FacetList(facetsController) { facet, isSelected in
            VStack {
              FacetRow(facet: facet, isSelected: isSelected)
              Divider()
            }
            .padding(.vertical, 7)
          } noResults: {
            Text("No facets found")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
      }
      .padding()
    }
    
    private func facetsButton() -> some View {
      Button(action: {
        withAnimation {
          isPresentingFacets.toggle()
        }
      },
      label: {
        Image(systemName: "line.horizontal.3.decrease.circle")
          .font(.title)
      })
    }

  }

}


@available(iOS 15.0, *)
struct GettingStartedSwiftUI_iOS15_Preview: PreviewProvider {
  
  static let algoliaController = GettingStartedSwiftUI_iOS15.AlgoliaController()
  
  static func connect(_ algoliaController: GettingStartedSwiftUI_iOS15.AlgoliaController, _ contentView: GettingStartedSwiftUI_iOS15.ContentView) {
    algoliaController.hitsInteractor.connectController(contentView.hitsController)
    algoliaController.suggestionsHitsInteractor.connectController(contentView.suggestionsController)
    algoliaController.statsInteractor.connectController(contentView.statsController)
    algoliaController.queryInputInteractor.connectController(contentView.queryInputConntroller)
    algoliaController.facetListInteractor.connectController(contentView.facetsController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
  }
  
  static var previews: some View {
    let contentView = GettingStartedSwiftUI_iOS15.ContentView()
    NavigationView {
      contentView
    }.onAppear {
      connect(algoliaController, contentView)
      algoliaController.searcher.search()
      algoliaController.suggestionsSearcher.search()
    }
  }
}

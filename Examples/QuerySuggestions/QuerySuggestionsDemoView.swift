//
//  QuerySuggestionsDemoView.swift
//  QuerySuggestions
//
//  Created by Vladislav Fitc on 02/06/2023.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct Item: Codable {
  let name: String
  let image: URL
}

struct ItemHitRow: View {
  
  let itemHit: Hit<Item>
  
  init(_ itemHit: Hit<Item>) {
    self.itemHit = itemHit
  }
  
  var body: some View {
    HStack(spacing: 14) {
      AsyncImage(url: itemHit.object.image, content: { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      }, placeholder: {
        ProgressView()
      })
      .frame(width: 40, height: 40)
      if let highlightedName = itemHit.hightlightedString(forKey: "name") {
        Text(highlightedString: highlightedName,
             highlighted: { Text($0).bold() })
      } else {
        Text(itemHit.object.name)
      }
      Spacer()
    }
  }
  
}

final class SearchViewModel: ObservableObject {
  
  @Published var searchQuery: String {
    didSet {
      notifyQueryChanged()
    }
  }
    
  @Published var suggestions: [QuerySuggestion]
  
  var hits: PaginatedDataViewModel<AlgoliaHitsPage<Hit<Item>>>
  
  private var itemsSearcher: HitsSearcher
    
  private var suggestionsSearcher: HitsSearcher
        
  private var didSubmitSuggestion: Bool
    
  init() {
    let appID: ApplicationID = "latency"
    let apiKey: APIKey = "af044fb0788d6bb15f807e4420592bc5"
    let itemsSearcher = HitsSearcher(appID: appID,
                                     apiKey: apiKey,
                                     indexName: "instant_search")
    self.itemsSearcher = itemsSearcher
    self.suggestionsSearcher = HitsSearcher(appID: appID,
                                            apiKey: apiKey,
                                            indexName: "query_suggestions")
    self.hits = itemsSearcher.paginatedData(of: Hit<Item>.self)
    searchQuery = ""
    suggestions = []
    didSubmitSuggestion = false
    suggestionsSearcher.onResults.subscribe(with: self) { _, response in
      do {
        self.suggestions = try response.extractHits()
      } catch _ {
        self.suggestions = []
      }
    }.onQueue(.main)
    suggestionsSearcher.search()
  }
  
  func completeSuggestion(_ suggestion: String) {
    searchQuery = suggestion
  }
    
  func submitSuggestion(_ suggestion: String) {
    didSubmitSuggestion = true
    searchQuery = suggestion
  }
    
  func submitSearch() {
    suggestions = []
    itemsSearcher.request.query.query = searchQuery
    itemsSearcher.search()
  }
  
  private func notifyQueryChanged() {
    if didSubmitSuggestion {
      didSubmitSuggestion = false
      submitSearch()
    } else {
      suggestionsSearcher.request.query.query = searchQuery
      suggestionsSearcher.search()
      itemsSearcher.request.query.query = searchQuery
      itemsSearcher.search()
    }
  }
  
  deinit {
    suggestionsSearcher.onResults.cancelSubscription(for: self)
  }
  
}

public struct SearchView: View {
  
  @StateObject var viewModel = SearchViewModel()
    
  public var body: some View {
    InfiniteList(viewModel.hits, itemView: { hit in
      ItemHitRow(hit)
        .padding()
      Divider()
    }, noResults: {
      Text("No results found")
    })
    .navigationTitle("Query suggestions")
    .searchable(text: $viewModel.searchQuery,
                prompt: "Laptop, smartphone, tv",
                suggestions: {
      ForEach(viewModel.suggestions, id: \.query) { suggestion in
        SuggestionRow(suggestion: suggestion,
                      onSelection: viewModel.submitSuggestion,
                      onTypeAhead: viewModel.completeSuggestion)
      }
    })
    .onSubmit(of: .search, viewModel.submitSearch)
  }
  
}

@available(iOS 15.0, *)
class SearchPreview: PreviewProvider {
  
  static var previews: some View {
    NavigationView {
      SearchView()
    }
  }
  
}

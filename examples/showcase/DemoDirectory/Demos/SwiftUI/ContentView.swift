//
//  ContentView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ContentView: View {
  
  let areFacetsSearchable: Bool
  let allowSuggestions: Bool = true
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var statsController: StatsTextObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<StoreItem>>
  
  // Shared models
  @ObservedObject var currentFiltersController: CurrentFiltersObservableController
  @ObservedObject var sortByController: SelectableSegmentObservableController

  // Suggestions models
  @ObservedObject var suggestionsController: HitsObservableController<QuerySuggestion>
  
  // Facet list models
  @ObservedObject var facetSearchQueryInputController: QueryInputObservableController
  @ObservedObject var facetListController: FacetListObservableController
  @ObservedObject var filterClearController: FilterClearObservableController
  
  // State
  @State private var isPresentingFacets = false
  @State private var isEditing = false
  
  @Environment(\.presentationMode) var presentation
  
  init(areFacetsSearchable: Bool) {
    statsController = .init()
    hitsController = .init()
    currentFiltersController = .init()
    queryInputController = .init()
    filterClearController = .init()
    suggestionsController = .init()
    sortByController = .init()
    facetSearchQueryInputController = .init()
    facetListController = .init()
    self.areFacetsSearchable = areFacetsSearchable
  }
  
  var body: some View {
      VStack(spacing: 7) {
        SearchBar(text: $queryInputController.query,
                  isEditing: $isEditing,
                  onSubmit: queryInputController.submit)
        if isEditing && allowSuggestions {
          SuggestionsView(query: $queryInputController.query,
                          isEditing: $isEditing,
                          suggestionsController: suggestionsController)
        } else {
          VStack {
            HStack {
              Text(statsController.stats)
                .fontWeight(.medium)
              Spacer()
              if #available(iOS 14.0, *) {
                sortMenu()
              }
            }
            HitsList(hitsController) { (hit, index) in
              ShopItemRow(product: hit)
            } noResults: {
              Text("No Results")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
        }
      }
      .padding()
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing: facetsButton())
      .sheet(isPresented: $isPresentingFacets) {
        NavigationView {
          FacetsView(isSearchable: areFacetsSearchable,
                     facetSearchQueryInputController: facetSearchQueryInputController,
                     facetListController: facetListController,
                     statsController: statsController,
                     currentFiltersController: currentFiltersController,
                     filterClearController: filterClearController)
        }
      }
  }
  
  @available(iOS 14.0, *)
  private func sortMenu() -> some View {
    Menu {
      ForEach(0 ..< sortByController.segmentsTitles.count, id: \.self) { index in
        let indexName = sortByController.segmentsTitles[index]
        Button(indexName) {
          sortByController.select(index)
        }
      }
    } label: {
      if let index = sortByController.selectedSegmentIndex {
        Label(sortByController.segmentsTitles[index], systemImage: "arrow.up.arrow.down.circle")
      }
    }
  }
  
  private func facetsButton() -> some View {
    Button(action: {
      withAnimation {
        isPresentingFacets.toggle()
      }
    },
    label: {
      let imageName = currentFiltersController.filters.isEmpty ? "line.horizontal.3.decrease.circle" : "line.horizontal.3.decrease.circle.fill"
      Image(systemName: imageName)
        .font(.title)
    })
  }
    
}

struct ContentView_Previews : PreviewProvider {
  
  static let viewModel = AlgoliaController.test(areFacetsSearchable: true)
  
  static var previews: some View {
    let contentView = ContentView(areFacetsSearchable: viewModel.areFacetsSearchable)
    let _ = viewModel.setup(contentView)
    NavigationView {
      contentView
    }
  }
  
}

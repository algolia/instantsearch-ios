//
//  FacetsView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchSwiftUI
import SwiftUI

struct FacetsView: View {

  let isSearchable: Bool
  
  @ObservedObject var facetSearchQueryInputController: QueryInputObservableController
  @ObservedObject var facetListController: FacetListObservableController
  @ObservedObject var statsController: StatsTextObservableController
  @ObservedObject var currentFiltersController: CurrentFiltersObservableController
  @ObservedObject var filterClearController: FilterClearObservableController

  @State private var isEditingFacetSearch = false
  
  var body: some View {
    let facetList =
    VStack {
      if isSearchable {
        SearchBar(text: $facetSearchQueryInputController.query,
                  isEditing: $isEditingFacetSearch,
                  placeholder: "Search for facet")
      }
      FacetList(facetListController) { facet, isSelected in
        VStack {
          FacetRow(facet: facet, isSelected: isSelected)
          Divider()
        }
      } noResults: {
        Text("No facets found")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .padding()
    .navigationBarTitle("Brand")
    
    if #available(iOS 14.0, *) {
      facetList.toolbar {
        ToolbarItem(placement: .bottomBar) {
          Spacer()
        }
        ToolbarItem(placement: .bottomBar) {
          Text(statsController.stats)
        }
        ToolbarItem(placement: .bottomBar) {
          Spacer()
        }
        ToolbarItem(placement: .bottomBar) {
          Button(action: filterClearController.clear,
                 label: { Image(systemName: "trash") }
          ).disabled(currentFiltersController.filters.isEmpty)
        }
      }
    } else {
      facetList
    }
    
  }
  
}

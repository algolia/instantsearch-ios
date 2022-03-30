//
//  GettingStartedSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 07/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

extension GettingStartedGuide {
  enum SwiftUI {
    enum StepOne {}
    enum StepTwo {}
    enum StepThree {}
    enum StepFour {}
    enum StepFive {}
    enum StepSix {}
    enum StepSeven {}
  }
}

extension GettingStartedGuide.SwiftUI {

  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController = .init()
    @ObservedObject var hitsController: HitsObservableController<Item> = .init()
    @ObservedObject var statsController: StatsTextObservableController = .init()
    @ObservedObject var facetsController: FacetListObservableController = .init()

    @State private var isPresentingFacets = false
    @State private var isEditing = false
    
    var body: some View {
      VStack(spacing: 7) {
        SearchBar(text: $queryInputController.query,
                  isEditing: $isEditing,
                  onSubmit: queryInputController.submit)
        Text(statsController.stats)
          .fontWeight(.medium)
        VStack {
          HitsList(hitsController) { (hit, _) in
            VStack(alignment: .leading, spacing: 10) {
              Text(hit?.name ?? "").padding(.all, 10)
              Divider()
            }
          } noResults: {
            Text("No Results")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
      }
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing: facetsButton())
      .sheet(isPresented: $isPresentingFacets, content: facetsView)
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
  
  
  class AlgoliaController {
    
    let searcher: HitsSearcher
    let queryInputInteractor: QueryInputInteractor
    let hitsInteractor: HitsInteractor<Item>
    let statsInteractor: StatsInteractor
    
    let filterState: FilterState
    let facetListInteractor: FacetListInteractor

    init() {
      self.searcher = HitsSearcher(appID: "latency",
                                          apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                          indexName: "bestbuy")
      self.queryInputInteractor = .init()
      self.hitsInteractor = .init()
      self.statsInteractor = .init()
      
      self.filterState = .init()
      self.facetListInteractor = .init()
      
      setupConnections()
    }
    
    func setupConnections() {
      queryInputInteractor.connectSearcher(searcher)
      searcher.connectFilterState(filterState)
      hitsInteractor.connectSearcher(searcher)
      statsInteractor.connectSearcher(searcher)
      
      facetListInteractor.connectSearcher(searcher, with: "manufacturer")
      facetListInteractor.connectFilterState(filterState, with: "manufacturer", operator: .or)
    }
        
  }
    
}

struct GettingStartedPreviews : PreviewProvider {
  
  static let algoliaController = GettingStartedGuide.SwiftUI.AlgoliaController()
  
  static func connect(_ algoliaController: GettingStartedGuide.SwiftUI.AlgoliaController, _ contentView: GettingStartedGuide.SwiftUI.ContentView) {
    algoliaController.hitsInteractor.connectController(contentView.hitsController)
    algoliaController.statsInteractor.connectController(contentView.statsController)
    algoliaController.queryInputInteractor.connectController(contentView.queryInputController)
    algoliaController.facetListInteractor.connectController(contentView.facetsController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
  }
  
  static var previews: some View {
    let contentView = GettingStartedGuide.SwiftUI.ContentView()
    NavigationView {
      contentView
    }.onAppear {
      connect(algoliaController, contentView)
      algoliaController.searcher.search()
    }
  }
}

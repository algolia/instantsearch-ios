//
//  SearchDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct SearchDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  class Controller {
    let demoController: PetSmartDemoController
    let hitsController: HitsObservableController<Hit<PetSmartStoreItem>>
    let searchBoxController: SearchBoxObservableController
    let statsController: StatsTextObservableController
    let loadingController: LoadingObservableController
    let brandController: FacetListObservableController
    let ratingController: FacetListObservableController

    init(searchTriggeringMode: SearchTriggeringMode) {
      demoController = PetSmartDemoController(searchTriggeringMode: searchTriggeringMode)
      hitsController = HitsObservableController()
      searchBoxController = SearchBoxObservableController()
      statsController = StatsTextObservableController()
      loadingController = LoadingObservableController()
      brandController = FacetListObservableController()
      ratingController = FacetListObservableController()
      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.hitsInteractor.connectController(hitsController)
      demoController.statsConnector.connectController(statsController)
      demoController.loadingConnector.connectController(loadingController)
      let ratingPresenter = FacetListPresenter(sortBy: [.isRefined, .alphabetical(order: .descending)])
      demoController.ratingFacetList.connectController(ratingController, with: ratingPresenter)
      let brandPresenter = FacetListPresenter(sortBy: [.isRefined, .count(order: .ascending), .alphabetical(order: .ascending)])
      demoController.brandFacetList.connectController(brandController, with: brandPresenter)
      demoController.searcher.search()
    }
  }

  struct ContentView: View {
    @StateObject var hitsViewModel: PaginatedDataViewModel<AlgoliaHitsPage<Hit<PetSmartStoreItem>>>
    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var statsController: StatsTextObservableController
    @ObservedObject var loadingController: LoadingObservableController
    @ObservedObject var brandController: FacetListObservableController
    @ObservedObject var ratingController: FacetListObservableController

    var didTapPets: () -> Void
    var didTapToys: () -> Void
    var didTapClear: () -> Void
    
    @State private var isShowingBrands = false
    @State private var isShowingRating = false
    @State private var isFilteringPets = false
    @State private var isFilteringToys = false

    var body: some View {
      VStack {
        HStack {
          Text(statsController.stats)
          Spacer()
          if loadingController.isLoading {
            ProgressView()
          }
          Button {
            isShowingBrands.toggle()
          } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
          Button {
            isShowingRating.toggle()
          } label: {
            Image(systemName: "star.leadinghalf.filled")
          }
          Button {
            didTapPets()
            isFilteringPets.toggle()
          } label: {
            Image(systemName: "pawprint")
              .padding(.all, 2)
              .background(isFilteringPets ? Color.blue : Color.clear)
              .foregroundColor(isFilteringPets ? Color.white : Color.blue)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .overlay(
                  RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.blue, lineWidth: 1)
              )
          }
          Button {
            didTapToys()
            isFilteringToys.toggle()
          } label: {
            Image(systemName: "teddybear")
              .padding(.all, 2)
              .background(isFilteringToys ? Color.blue : Color.clear)
              .foregroundColor(isFilteringToys ? Color.white : Color.blue)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .overlay(
                  RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.blue, lineWidth: 1)
              )
          }
          Button {
            isFilteringPets = false
            isFilteringToys = false
            didTapClear()
          } label: {
            Image(systemName: "trash")
          }
        }
        .padding(.horizontal, 20)
        InfiniteList(hitsViewModel) { hit in
          ProductRow(petSmartItem: hit)
            .padding()
            .frame(height: 100)
        } noResults: {
          Text("No Results")
        }
      }
      .searchable(text: $searchBoxController.query)
      .onSubmit(of: .search) {
        searchBoxController.submit()
      }
      .sheet(isPresented: $isShowingBrands) {
        NavigationView {
          ScrollView {
            FacetList(brandController) { facet, selected in
              FacetRow(facet: facet, isSelected: selected)
                .padding()
            }
          }
          .navigationTitle("Brand")
        }
      }
      .sheet(isPresented: $isShowingRating) {
        NavigationView {
          ScrollView {
            FacetList(ratingController) { facet, selected in
              FacetRow(facet: facet, isSelected: selected)
                .padding()
            }
          }
          .navigationTitle("Rating")
        }
      }
    }
  }

  static func contentView(with controller: Controller) -> ContentView {
    let hitsViewModel = controller.demoController.searcher.paginatedData(of: Hit<PetSmartStoreItem>.self)
    let filterState = controller.demoController.filterState
    filterState.onChange.subscribe(with: hitsViewModel) { viewModel, _ in
      Task {
        await viewModel.reset()
      }
    }
    func clearFilters() {
      filterState.removeAll()
      filterState.notifyChange()
    }
    func toggleToys() {
      filterState[or: "custom_category", Filter.Facet.self].toggle(Filter.Facet(attribute: "custom_categories", value: "200212"))
      filterState.notifyChange()
    }
    func togglePets() {
      filterState[or: "custom_category", Filter.Facet.self].toggle(Filter.Facet(attribute: "custom_categories", value: "600000"))
      filterState.notifyChange()
    }
    return ContentView(hitsViewModel: hitsViewModel,
                       searchBoxController: controller.searchBoxController,
                       statsController: controller.statsController,
                       loadingController: controller.loadingController,
                       brandController: controller.brandController,
                       ratingController: controller.ratingController,
                       didTapPets: togglePets,
                       didTapToys: toggleToys,
                       didTapClear: clearFilters)
    
  }

  static func viewController(searchTriggeringMode: SearchTriggeringMode) -> UIViewController {
    let controller = Controller(searchTriggeringMode: searchTriggeringMode)
    let contentView = contentView(with: controller)
    return CommonSwiftUIDemoViewController(controller: controller,
                                           rootView: contentView)
  }

  static let controller = Controller(searchTriggeringMode: .searchAsYouType)
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
    }
  }
}

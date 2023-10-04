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

    init(searchTriggeringMode: SearchTriggeringMode) {
      demoController = PetSmartDemoController(searchTriggeringMode: searchTriggeringMode)
      hitsController = HitsObservableController()
      searchBoxController = SearchBoxObservableController()
      statsController = StatsTextObservableController()
      loadingController = LoadingObservableController()
      brandController = FacetListObservableController()
      demoController.searchBoxConnector.connectController(searchBoxController)
      demoController.hitsInteractor.connectController(hitsController)
      demoController.statsConnector.connectController(statsController)
      demoController.loadingConnector.connectController(loadingController)
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
    var didTapClear: () -> Void
    
    @State private var isShowingBrands = false

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
            didTapClear()
          } label: {
            Image(systemName: "trash.circle")
          }
        }
        .padding(.trailing, 20)
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
      .padding(.horizontal, 15)
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
    }
  }

  static func contentView(with controller: Controller) -> ContentView {
    let hitsViewModel = controller.demoController.searcher.paginatedData(of: Hit<PetSmartStoreItem>.self)
    controller.demoController.filterState.onChange.subscribe(with: hitsViewModel) { viewModel, _ in
      Task {
        await viewModel.reset()
      }
    }
    return ContentView(hitsViewModel: hitsViewModel,
                       searchBoxController: controller.searchBoxController,
                       statsController: controller.statsController,
                       loadingController: controller.loadingController,
                       brandController: controller.brandController) {
      controller.demoController.filterState.removeAll(for: "brand")
      controller.demoController.filterState.notifyChange()
    }
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

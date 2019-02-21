//
//  MultiHitsController.swift
//  InstantSearch
//
//  Created by Guy Daher on 21/02/2019.
//

import Foundation
import UIKit

class MultiHitsControllerV2 {

  let hitsViewModels: [HitsViewModelV2]
  let searchViewModel: SearchViewModelV2
  var hitsWidgets: WeakSet<HitsWidgetV2>
  var searchWidgets: WeakSet<SearchWidgetV2>
  let indexQueries: [IndexQuery]

  var hitsTableViewDataSource: HitsTableViewDataSourceV2?
  var hitsTableViewDelegate: HitsTableViewDelegateV2?
  var hitsCollectionViewDataSource: HitsCollectionViewDataSourceV2?
  var hitsCollectionViewDelegate: HitsCollectionViewDelegateV2?

  // DISCUSSION: it s confusing to have hitsPerPage not in hitsSettings for the dev, although one is at the query level, the other at the viewModel level.
  // DISCUSSION: instead of using delegate pattern to reload hitsWidgets, we can offer a closure as well to inform the caller to refresh their.
  public init(indexQueries: [IndexQuery], searchWidgets: [SearchWidgetV2], hitsWidgets: [HitsWidgetV2] = [], hitsSettings: HitsSettings? = nil, querySettings: QuerySettings? = nil) {

    self.indexQueries = indexQueries
    self.hitsViewModels = Array(repeating: HitsViewModelV2(hitsSettings: hitsSettings), count: indexQueries.count)
    self.searchViewModel = SearchViewModelV2()
    self.hitsWidgets = WeakSet<HitsWidgetV2>()
    self.hitsWidgets.add(hitsWidgets)
    self.searchWidgets = WeakSet<SearchWidgetV2>()
    self.searchWidgets.add(searchWidgets)
    indexQueries.map { $0.query }.forEach { $0.hitsPerPage = querySettings?.hitsPerPage }

    searchWidgets.forEach {
      $0.observeSearchEvents { text in

        // We're observing new searches so we need to reset the page to 0?
        indexQueries.map { $0.query }.forEach { $0.query = text }

        self.searchViewModel.multipleQueries(indexQueries, strategy: nil, completionHandler: { (multipleResult, _) in

          for (index, result) in multipleResult.enumerated() {
            self.hitsViewModels[index].update(result)
          }

          self.hitsWidgets.forEach { $0.reload() }

        })
      }
    }

//    // DISCUSSION: concerning unowned: the controller owns the viewmodel, so if it is deallocated, then viewmodel is deallocated so this should not be called
//    hitsViewModel.observeSearchPage { [unowned self] page, update in
//
//      query.page = page
//
//      self.searchViewModel.search(index: index, query, completionHandler: { (result, _) in
//        update(result) // Discussion: Second way to update the result of the hitsViewModel
//        self.hitsWidgets.forEach { $0.reload() }
//      })

    }

  // DISCUSSION: should we specify the range of the requests that need to be displayed ??
//  func setupDataSourceForTableView(_ tableView: UITableView, with hitsTableViewCellHandler: @escaping HitsTableViewCellHandler) {
//    hitsTableViewDataSource = HitsTableViewDataSourceV2(hitsViewModel: hitsViewModel, hitsTableViewCellHandler: hitsTableViewCellHandler)
//    tableView.dataSource = hitsTableViewDataSource
//  }

}

//
//  HitsControllerV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation
import UIKit

@objc protocol HitsWidgetV2: class {
  func reload()
}

extension UITableView: HitsWidgetV2 {
  func reload() {
    reloadData()
  }
}

extension UICollectionView: HitsWidgetV2 {
  func reload() {
    reloadData()
  }
}

public typealias Hit = [String: Any] // could also be strongly typed if we use the power of generics
public typealias HitsTableViewCellHandler = (Hit) -> UITableViewCell
public typealias HitsCollectionViewCellHandler = (Hit) -> UICollectionViewCell

class HitsControllerV2 {

  let hitsViewModel: HitsViewModelV2
  let hitsWidgets = WeakSet<HitsWidgetV2>()
  let index: Index
  let query: Query

  var hitsTableViewDataSource: HitsTableViewDataSourceV2?

  // DISCUSSION: it s confusing to have hitsPerPage not in hitsSettings for the dev, although one is at the query level, the other at the viewModel level.
  public init(index: Index, query: Query, hitsWidgets: [HitsWidgetV2] = [], hitsSettings: HitsSettings? = nil, querySettings: QuerySettings? = nil) {

    self.index = index
    self.query = query
    query.hitsPerPage = querySettings?.hitsPerPage
    hitsViewModel = HitsViewModelV2(hitsSettings: hitsSettings)
    // DISCUSSION: the controller owns the viewmodel, so if it is deallocated, then viewmodel is deallocated so this should not be called
    hitsViewModel.observeSearchPage { [unowned self] page, update in

      query.page = page

      // TODO: Once ready, use the searchCoordinator + index + query to search here and get the appropriate results
      self.index.search(query) { _, _ in
        update(Result(value: SearchResults(nbHits: 0, hits: [[:]])))
        self.hitsWidgets.forEach { $0.reload() }
        // TODO: Scroll top if first page?
      }
    }

    func setupDataSource(for tableView: UITableView, with hitsTableViewCellHandler: @escaping HitsTableViewCellHandler) {
      hitsTableViewDataSource = HitsTableViewDataSourceV2(hitsViewModel: hitsViewModel, hitsTableViewCellHandler: hitsTableViewCellHandler)
      tableView.dataSource = hitsTableViewDataSource
    }
  }
}

class HitsTableViewDataSourceV2: NSObject, UITableViewDataSource {

  var hitsTableViewCellHandler: HitsTableViewCellHandler
  var hitsViewModel: HitsViewModelV2

  init(hitsViewModel: HitsViewModelV2, hitsTableViewCellHandler: @escaping HitsTableViewCellHandler) {
    self.hitsTableViewCellHandler = hitsTableViewCellHandler
    self.hitsViewModel = hitsViewModel
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsViewModel.numberOfRows()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let hit = hitsViewModel.hitForRow(at: indexPath)

    return hitsTableViewCellHandler(hit)
  }

}

public struct QuerySettings {
  public var hitsPerPage: UInt?
}

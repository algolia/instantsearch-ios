//
//  HitsControllerV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation
import UIKit

protocol HitsWidgetV2: class {
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

public typealias SearchHandler = (String) -> Void
public typealias Hit = [String: Any] // could also be strongly typed if we use the power of generics
public typealias HitsTableViewCellHandler = (Hit) -> UITableViewCell
public typealias HitsCollectionViewCellHandler = (Hit) -> UICollectionViewCell
public typealias HitsTableViewOnClickHandler = (Hit) -> Void
public typealias HitsCollectionViewOnClickHandler = (Hit) -> Void
public typealias ReloadHandler = () -> Void


//class SearchControllerV2 {
//
//  let searcher: SearcherV2
//  let index: Index
//  let query: Query
//
//  private var observations: [NSKeyValueObservation] = []
//
//  // TODOTODOTODO: This should change to updateHandler with the SearchResults? in that way, other hits controller, refinement controller etc can tune to that search controller
//  var reloadObservations = [ReloadHandler]()
//
//  // DISCUSSION: it s confusing to have hitsPerPage not in hitsSettings for the dev, although one is at the query level, the other at the viewModel level.
//  public init(searcherType: SearcherFactory.SearcherType) {
//
//    searcher = SearcherFactory.createSearcher(searcherType: searcherType)
//
//    let observation = query.observe(\.query, changeHandler: { [weak self] (query, _) in
//      guard let strongSelf = self else { return }
//      strongSelf.query.page = 0 // When query changes and we execute a new search, we want to get back to page 0
//      strongSelf.searchViewModel.search(index: index, query, completionHandler: { (result, _) in
//
//        // TODO: remove the hitsViewModel reload, and create a new hits Controller
//        strongSelf.hitsViewModel.update(result) // Discussion: first way to update result of the hitsViewModel
//        strongSelf.reloadObservations.forEach { $0() }
//      })
//    })
//    observations.append(observation)
//
//    // TODO: do the same for reacting to filterBuilder changes, and just launching new searches.
//
//    // DISCUSSION: concerning unowned: the controller owns the viewmodel, so if it is deallocated, then viewmodel is deallocated so this should not be called
//    hitsViewModel.subscribePageReload { [weak self] page in
//      guard let strongSelf = self else { return }
//      query.page = page
//
//      strongSelf.searchViewModel.search(index: index, query, completionHandler: { (result, _) in
//        strongSelf.hitsViewModel.update(result) // Discussion: Second way to update the result of the hitsViewModel Decision: Remove the closure method.
//        strongSelf.reloadObservations.forEach { $0() }
//      })
//
//    }
//  }
//
//  /// Use this to reload your table views and what not when
//  public func subscribeReload(using closure: @escaping ReloadHandler) {
//    reloadObservations.append(closure)
//  }
//
//}
//
//public struct QuerySettings {
//  public var hitsPerPage: UInt?
//}

//
//  HitsControllerV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation
import UIKit

public typealias ReloadHandler = () -> Void


class SearchControllerV2 {

  let searchers: [SearcherV2]
  let query: Query

  private var observations: [NSKeyValueObservation] = []

  // TODOTODOTODO: This should change to updateHandler with the SearchResults? in that way, other hits controller, refinement controller etc can tune to that search controller
  var reloadObservations = [ReloadHandler]()

  public init(query: Query, searchers: [SearcherV2]) {

    self.searchers = searchers
    self.query = query
    let observation = self.query.observe(\.query, changeHandler: { [weak self] (query, _) in
      guard let strongSelf = self else { return }
      strongSelf.query.page = 0 // When query changes and we execute a new search, we want to get back to page 0
      strongSelf.searchers.forEach{ $0.search() }
    })
    observations.append(observation)

    self.query.filterBuilder.observeFilterChanges {
      self.searchers.forEach{ $0.search() }
    }

    // There is also a search case when hitsViewModel is
    //    hitsViewModel.subscribePageReload { [weak self] page in
    //      guard let strongSelf = self else { return }
    //      query.page = page
    //
    //      strongSelf.searchViewModel.search(index: index, query, completionHandler: { (result, _) in
    //        strongSelf.hitsViewModel.update(result) // Discussion: Second way to update the result of the hitsViewModel Decision: Remove the closure method.
    //        strongSelf.reloadObservations.forEach { $0() }
    //      })

  }
}

class NewHitsController {
  public init(searcher: SingleIndexSearcher) {
    searcher.subscribeToSearchResults { (result) in
      // use hitsViewModel and update with result and launch a reload ?
    }
  }
}



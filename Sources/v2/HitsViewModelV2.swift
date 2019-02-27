//
//  HitsViewModelV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation

import UIKit

public class HitsViewModelV2 {

  public typealias SearchPageHandler = (_ page: UInt) -> Void

  let hitsSettings: HitsSettings

  var hitsResult: Result<Hits>?

  // DISCUSSION: is closure based observation the simplest DX to understand or should we think or reactive paradigm.
  var searchPageObservations = [SearchPageHandler]()

  // DISCUSSION: should we expose those through KVO? dynamic var in case someone wants to listen to them?
  // something like: viewModel.bind(\.navigationTitle, to: navigationItem, at: \.title),

  struct Hits {
    public var nbHits: Int
    public var allHits: [[String: Any]]
    public var latestHits: [[String: Any]]
    public var page: Int
    public var nbPages: Int
    public var query: String?
    public var queryId: String?
  }

  public init(infiniteScrolling: Bool = true,
              remainingItemsBeforeLoading: UInt = 5,
              showItemsOnEmptyQuery: Bool = true) {
    self.hitsSettings = HitsSettings(infiniteScrolling: infiniteScrolling,
                                     remainingItemsBeforeLoading: remainingItemsBeforeLoading,
                                     showItemsOnEmptyQuery: showItemsOnEmptyQuery)
  }

  public init(hitsSettings: HitsSettings? = nil) {
    self.hitsSettings = hitsSettings ?? HitsSettings()
  }

  public func subscribePageReload(using closure: @escaping SearchPageHandler) {
    searchPageObservations.append(closure)
    closure(0) // DISCUSSION: Do we really call for 1?
  }

  public func clearSearchPageObservations() {
    searchPageObservations = []
  }

  public func update(_ searchResults: Result<SearchResults>) {

    func extractHitsFromSearchResults(searchResults: SearchResults) -> Hits {
      return Hits(nbHits: searchResults.nbHits, allHits: searchResults.allHits, latestHits: searchResults.latestHits, page: searchResults.page, nbPages: searchResults.nbPages, query: searchResults.query, queryId: searchResults.queryID)
    }

    switch searchResults {
    case .fail(let error): hitsResult = Result(error: error)
    case .success(let results):
      hitsResult = Result(value: extractHitsFromSearchResults(searchResults: results))
    }

    // TODO: Attention: Depending of the page of the result, we need to decide if we append or not for allHits
  }

  public func numberOfRows() -> Int {
    guard let hits = hitsResult?.value else { return 0 }

    if let query = hits.query, query.isEmpty, !hitsSettings.showItemsOnEmptyQuery {
      return 0
    } else {
      return hits.allHits.count
    }
  }

  public func hasMoreResults() -> Bool {
    return hasMorePages()
  }

  public func loadMoreResults() {
    guard hasMorePages() else { return } // Throw error?
    notifyNextPage()
  }

  public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
    guard let hits = hitsResult?.value else { return [:] }

    loadMoreIfNecessary(rowNumber: indexPath.row)
    return hits.allHits[indexPath.row]
  }

  private func hasMorePages() -> Bool {
    guard let hits = hitsResult?.value else { return false }

    return hits.nbPages > hits.page + 1
  }

  private func notifyNextPage() {
    guard let hits = hitsResult?.value else { return }

    searchPageObservations.forEach { $0(UInt(hits.page + 1)) }
  }

  private func loadMoreIfNecessary(rowNumber: Int) {
    guard hitsSettings.infiniteScrolling, let hits = hitsResult?.value else { return }

    if rowNumber + Int(hitsSettings.remainingItemsBeforeLoading) >= hits.allHits.count {
      notifyNextPage()
    }
  }
}

public struct HitsSettings {
  public var infiniteScrolling: Bool = Constants.Defaults.infiniteScrolling
  public var remainingItemsBeforeLoading: UInt = Constants.Defaults.remainingItemsBeforeLoading
  public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
}

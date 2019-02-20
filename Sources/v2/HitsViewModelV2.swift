//
//  HitsViewModelV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation

import UIKit

public class HitsViewModelV2 {

  // DISCUSSION: Another way is to remove the resultHandler, and let the user to vm.update()... but he will need access to the vm inside the closure, leading to weak self...
  public typealias SearchPageHandler = (_ page: UInt, _ resultHandler: @escaping SearchPageResultHandler) -> Void
  public typealias SearchPageResultHandler = (_ result: Result<SearchResults>) -> Void

  let hitsSettings: HitsSettings

  var hitsResult: HitsResult?

  // DISCUSSION: is closure based observation the simplest DX to understand or should we think or reactive paradigm.
  var searchPageObservations = [SearchPageHandler]()

  // DISCUSSION: should we expose those through KVO? dynamic var in case someone wants to listen to them?
  // something like: viewModel.bind(\.navigationTitle, to: navigationItem, at: \.title),
  struct HitsResult {
    public var nbHits: Int
    public var allHits: [[String: Any]]
    public var latestHits: [[String: Any]]
    public var page: UInt
    public var nbPages: Int
    public var query: String
    public var queryId: String
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

  public func observeSearchPage(using closure: @escaping SearchPageHandler) {
    searchPageObservations.append(closure)
    closure(0, update(_:))
  }

  public func clearSearchPageObservations() {
    searchPageObservations = []
  }

  public func update(_ searchResults: Result<SearchResults>) {
    // use results to build a hitsResult.
  }

  public func numberOfRows() -> Int {
    guard let hitsResult = hitsResult else { return 0 }

    if hitsResult.query.isEmpty && !hitsSettings.showItemsOnEmptyQuery {
      return 0
    } else {
      return hitsResult.allHits.count
    }
  }

  public func hasMoreResults() -> Bool {
    return hasMorePages()
  }

  public func loadMoreResults() {
    guard hasMorePages() else { return } // Throw error?
    loadNextPage()
  }

  public func hitForRow(at indexPath: IndexPath) -> [String: Any] {

    loadMoreIfNecessary(rowNumber: indexPath.row)
    return hitsResult!.allHits[indexPath.row]
  }

  private func hasMorePages() -> Bool {
    guard let hitsResult = hitsResult else { return false }

    return hitsResult.nbPages > hitsResult.page + 1
  }

  private func loadNextPage() {
    guard let hitsResult = hitsResult else { return }

    searchPageObservations.forEach { $0(hitsResult.page + 1, update(_:)) }
  }

  private func loadMoreIfNecessary(rowNumber: Int) {
    guard hitsSettings.infiniteScrolling else { return }

    if rowNumber + Int(hitsSettings.remainingItemsBeforeLoading) >= hitsResult!.allHits.count {
      loadNextPage()
    }
  }
}

public struct HitsSettings {
  public var infiniteScrolling: Bool = Constants.Defaults.infiniteScrolling
  public var remainingItemsBeforeLoading: UInt = Constants.Defaults.remainingItemsBeforeLoading
  public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
}

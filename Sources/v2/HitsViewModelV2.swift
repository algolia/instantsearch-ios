//
//  HitsViewModelV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation

import UIKit

public class HitsViewModelV2 {

  public typealias SearchPageHandler = (_ page: UInt, _ resultHandler: ResultHandler) -> Void
  // Can replace results+error with the new Result class.
  public typealias ResultHandler = (_ results: SearchResults?, _ error: Error?, _ userInfo: [String: Any]) -> Void

  // public var hitsPerPage: UInt // this can be directly settable to the query
  public let infiniteScrolling: Bool
  public let remainingItemsBeforeLoading: UInt
  public let showItemsOnEmptyQuery: Bool

  var hitsResult: HitsResult?

  var searchHandler: SearchPageHandler

  struct HitsResult {
    public var nbHits: Int
    public var allHits: [[String: Any]]
    public var latestHits: [[String: Any]]
    public var page: UInt
    public var nbPages: Int
    public var query: String
    public var queryId: String
  }

  public init(infiniteScrolling: Bool = true, remainingItemsBeforeLoading: UInt = 10, showItemsOnEmptyQuery: Bool = true, searchPageHandler: @escaping SearchPageHandler) {
    self.infiniteScrolling = infiniteScrolling
    self.remainingItemsBeforeLoading = remainingItemsBeforeLoading
    self.showItemsOnEmptyQuery = showItemsOnEmptyQuery
    self.searchHandler = searchPageHandler

    self.searchHandler(0, setNewSearchResults)
  }

  private func setNewSearchResults(_ results: SearchResults?, _ error: Error?, _ userInfo: [String: Any]) {
    // use results to build a hitsResult.
  }

  public func numberOfRows() -> Int {
    guard let hitsResult = hitsResult else { return 0 }

    if hitsResult.query.isEmpty && !showItemsOnEmptyQuery {
      return 0
    } else {
      return hitsResult.allHits.count
    }
  }

  public func hasMoreResults() -> Bool {
    return hasMorePages()
  }

  private func hasMorePages() -> Bool {
    guard let hitsResult = hitsResult else { return false }

    return hitsResult.nbPages > hitsResult.page + 1
  }

  public func loadMoreResults() {
    guard hasMorePages() else { return } // Throw error?
    loadNextPage()
  }

  private func loadNextPage() {
    guard let hitsResult = hitsResult else { return }

    self.searchHandler(hitsResult.page + 1, setNewSearchResults)
  }

  public func hitForRow(at indexPath: IndexPath) -> [String: Any] {

    loadMoreIfNecessary(rowNumber: indexPath.row)
    return hitsResult!.allHits[indexPath.row]
  }

  func loadMoreIfNecessary(rowNumber: Int) {
    guard infiniteScrolling else { return }

    if rowNumber + Int(remainingItemsBeforeLoading) >= hitsResult!.allHits.count {
      loadNextPage()
    }
  }
}

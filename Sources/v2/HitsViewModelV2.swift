//
//  HitsViewModelV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation

import UIKit

struct ItemsPages<Item> {

  var pageToItems: [Int: [Item]]

  let latestPage: UInt
  let totalPageCount: Int
  let totalItemsCount: Int

  fileprivate var itemsSequence: [Item]

  mutating func insert(_ page: [Item], withNumber pageNumber: Int) {
    pageToItems[pageNumber] = page
    itemsSequence = pageToItems.sorted { $0.key < $1.key } .flatMap { $0.value }
  }

  func inserting(_ page: [Item], withNumber pageNumber: Int) -> ItemsPages {
    var mutableCopy = self
    mutableCopy.insert(page, withNumber: pageNumber)
    return mutableCopy
  }

  var hasMorePages: Bool {
    return totalPageCount > latestPage + 1
  }

}

extension ItemsPages: Sequence {
  func makeIterator() -> ItemsPageIterator<Item> {
    return ItemsPageIterator(itemsPages: self)
  }
}

extension ItemsPages: Collection {
  // Required nested types, that tell Swift what our collection contains
  typealias Index = Array<Item>.Index
  typealias Element = Array<Item>.Element

  // The upper and lower bounds of the collection, used in iterations
  var startIndex: Index { return itemsSequence.startIndex }
  var endIndex: Index { return itemsSequence.endIndex }

  // Required subscript, based on a dictionary index
  subscript(index: Index) -> Iterator.Element {
    get { return itemsSequence[index] }
  }

  // Method that returns the next index when iterating
  func index(after i: Index) -> Index {
    return itemsSequence.index(after: i)
  }
}

struct ItemsPageIterator<Item>: IteratorProtocol {

  private let itemsPages: ItemsPages<Item>
  private var iterator: Array<Item>.Iterator

  init(itemsPages: ItemsPages<Item>) {
    self.itemsPages = itemsPages
    self.iterator = itemsPages.itemsSequence.makeIterator()
  }

  mutating func next() -> Item? {
    return iterator.next()
  }

}

extension ItemsPages where Item == HitsViewModelV2.Entity {

  init(searchResults: SearchResults) {
    let pageNumber = searchResults.page
    let hits = searchResults.latestHits
    pageToItems = [pageNumber: hits]
    latestPage = UInt(searchResults.page)
    totalPageCount = searchResults.nbPages
    totalItemsCount = searchResults.nbHits
    itemsSequence = searchResults.latestHits
  }

}

struct QueryMetaData {
  // This is the query in the search bar
  let queryText: String?

  // This is all params that were applied (query, filters etc)
  let rawQuery: String?

  // This is the query Id
  let queryID: String?

  init(searchResults: SearchResults) {
    queryText = searchResults.query
    queryID = searchResults.queryID
    rawQuery = searchResults.params?.build()
  }

}

public class HitsViewModelV2 {

  public typealias SearchPageHandler = (_ page: UInt) -> Void
  typealias Entity = [String: Any]

  let hitsSettings: HitsSettings

  var hits: ItemsPages<Entity>?

  var queryMetaData: QueryMetaData?
  // DISCUSSION: is closure based observation the simplest DX to understand or should we think or reactive paradigm.
  var searchPageObservations = [SearchPageHandler]()

  // DISCUSSION: should we expose those through KVO? dynamic var in case someone wants to listen to them?
  // something like: viewModel.bind(\.navigationTitle, to: navigationItem, at: \.title),

  struct HitsModel {
    // Cached hits that we received
    public var hitsForPage: [Int: Entity] = [:]

    // Metadata for the latest search result
    public var latestPage: Int
    public var totalPageCount: Int
    public var totalHitsCount: Int
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

  var pages: ItemsPages<Entity>?

  func extractHitsPage(from searchResults: SearchResults) -> (pageNumber: Int, hits: [Entity]) {
    return (0, [])
  }

  public func update(_ searchResults: SearchResults) {

    let queryMetaData = QueryMetaData(searchResults: searchResults)

    let (pageNumber, pageHits) = extractHitsPage(from: searchResults)

    if let currentHits = hits, let currentQueryMedata = self.queryMetaData, queryMetaData.rawQuery == currentQueryMedata.rawQuery {
      hits = currentHits.inserting(pageHits, withNumber: pageNumber)
    } else {
      hits = ItemsPages(searchResults: searchResults)
    }

    self.queryMetaData = queryMetaData

//    let (pageNumber, hits) = extractHitsPage(from: searchResults)
//
//    guard var existingPages = pages else {
//
//      return
//    }
//
//    existingPages.insert(hits, withNumber: pageNumber)
//
//
//    hitsResult = Result(value: extractHitsModelFromSearchResults(searchResults: searchResults))
//

    // TODO: Attention: Depending of the page of the result, we need to decide if we append or not for allHits
  }

  public func numberOfRows() -> Int {
    guard let hits = hits else { return 0 }

    if let queryText = queryMetaData?.queryText, queryText.isEmpty, !hitsSettings.showItemsOnEmptyQuery {
      return 0
    } else {
      return hits.count
    }
  }

  public func hasMoreResults() -> Bool {
    guard let hits = hits else { return false }
    return hits.hasMorePages
  }

  public func loadMoreResults() {
    guard let hits = hits, hits.hasMorePages else { return } // Throw error?
    notifyNextPage()
  }

  public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
    guard let hits = hits else { return [:] }

    loadMoreIfNecessary(rowNumber: indexPath.row)
    return hits[indexPath.row]
  }

  private func notifyNextPage() {
    guard let hits = hits else { return }

    searchPageObservations.forEach { $0(hits.latestPage + 1) }
  }

  // TODO: Here we're always loading the next page, but we don't handle the case where a page is missing in the middle for some reason
  // So we will need to detect which page the row corresponds at, and check if we're missing the page. then check the threshold offset to determine
  // if we load previous or next page (in case we don't have them loaded/cached already in our itemsPage struct
  private func loadMoreIfNecessary(rowNumber: Int) {

    guard hitsSettings.infiniteScrolling, let hits = hits else { return }

    if rowNumber + Int(hitsSettings.remainingItemsBeforeLoading) >= hits.count {
      // TODO: Check if already loaded the page, we don t want to reload when scrolling back up
      // ALSO IF WE RE IN LAST PAGE
      notifyNextPage()
    }
  }
}

public struct HitsSettings {
  public var infiniteScrolling: Bool = Constants.Defaults.infiniteScrolling
  public var remainingItemsBeforeLoading: UInt = Constants.Defaults.remainingItemsBeforeLoading
  public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
}

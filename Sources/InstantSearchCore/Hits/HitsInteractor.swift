//
//  HitsInteractor.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation
import AlgoliaSearchClient

/// Component that manages and displays a list of search results
public class HitsInteractor<Record: Codable>: AnyHitsInteractor {

  public typealias Result = HitsExtractable & SearchStatsConvertible

  /// Hits settings
  public let settings: Settings

  internal let paginator: Paginator<Record>
  private var isLastQueryEmpty: Bool = true
  private let infiniteScrollingController: InfiniteScrollable
  private let mutationQueue: OperationQueue

  /// Event triggered when a search request has changed
  public let onRequestChanged: Observer<Void>

  /// Event triggered when a new search result received
  public let onResultsUpdated: Observer<Result>

  /// Event triggered when an error occured in hits
  public let onError: Observer<Swift.Error>

  /// Results page loading logic
  public var pageLoader: PageLoadable? {

    get {
      infiniteScrollingController.pageLoader
    }

    set {
      infiniteScrollingController.pageLoader = newValue
    }

  }

  /// Value defines how many pages of hits might be kept in memory
  /// before and after the current page
  /// When set `nil`, all the fetched pages will stay in memory
  /// Default value: 3
  public var pageCleanUpOffset: Int? {
    get {
      return paginator.pageCleanUpOffset
    }

    set {
      paginator.pageCleanUpOffset = newValue
    }
  }

  convenience public init(infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                          showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery) {
    let settings = Settings(infiniteScrolling: infiniteScrolling,
                            showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(settings: settings)
  }

  public convenience init(settings: Settings? = nil) {
    self.init(settings: settings,
              paginationController: Paginator<Record>(),
              infiniteScrollingController: InfiniteScrollingController())
    Telemetry.shared.trace(type: .hits,
                           parameters: settings.flatMap { settings in
                             [
                              settings.infiniteScrolling == Constants.Defaults.infiniteScrolling ? .none : .infiniteScrolling,
                              settings.showItemsOnEmptyQuery == Constants.Defaults.showItemsOnEmptyQuery ? .none : .showItemsOnEmptyQuery
                             ]
                           } ?? []
                           )
  }

  internal init(settings: Settings? = nil,
                paginationController: Paginator<Record>,
                infiniteScrollingController: InfiniteScrollable) {
    self.settings = settings ?? Settings()
    self.paginator = paginationController
    self.infiniteScrollingController = infiniteScrollingController
    self.onRequestChanged = .init()
    self.onResultsUpdated = .init()
    self.onError = .init()
    self.mutationQueue = .init()
    self.mutationQueue.maxConcurrentOperationCount = 1
    self.mutationQueue.qualityOfService = .userInitiated
  }

  public func numberOfHits() -> Int {
    guard let hitsPageMap = paginator.pageMap, !paginator.isInvalidated else { return 0 }

    if isLastQueryEmpty && !settings.showItemsOnEmptyQuery {
      return 0
    } else {
      return hitsPageMap.count
    }
  }

  /// Map hits pages into the list of hits. The hits contained by pages unloaded from memory are represented as nil values.
  public var hits: [Record?] {
    guard let pageMap = paginator.pageMap else { return [] }
    return Array(pageMap)
  }

  public func hit(atIndex index: Int) -> Record? {
    guard let hitsPageMap = paginator.pageMap else { return nil }
    notifyDidPresentRow(atIndex: index)
    return hitsPageMap[index]
  }

  public func rawHitAtIndex(_ row: Int) -> [String: Any]? {
    guard let hit = hit(atIndex: row) else { return nil }
    return toRaw(hit)
  }

  public func genericHitAtIndex<R: Decodable>(_ index: Int) throws -> R? {
    guard let hit = hit(atIndex: index) else { return .none }
    return try cast(hit)
  }

  public func getCurrentHits() -> [Record] {
    guard let pageMap = paginator.pageMap else { return [] }
    return pageMap.loadedPages.flatMap { $0.items }
  }

  public func getCurrentGenericHits<R>() throws -> [R] where R: Decodable {
    guard let pageMap = paginator.pageMap else { return [] }
    return try pageMap.loadedPages.flatMap { $0.items }.map(cast)
  }

  public func getCurrentRawHits() -> [[String: Any]] {
    guard let pageMap = paginator.pageMap else { return [] }
    return pageMap.loadedPages.flatMap { $0.items }.compactMap(toRaw)
  }

  public func notifyDidPresentRow(atIndex rowIndex: Int) {
    guard
      case .on(let pageLoadOffset) = settings.infiniteScrolling,
      let hitsPageMap = paginator.pageMap else { return }

    infiniteScrollingController.calculatePagesAndLoad(currentRow: rowIndex, offset: pageLoadOffset, pageMap: hitsPageMap)
  }

}

extension HitsInteractor {

  public enum Error: Swift.Error, LocalizedError {
    case incompatibleRecordType

    var localizedDescription: String {
      return "Unexpected record type: \(String(describing: Record.self))"
    }

  }

}

private extension HitsInteractor {

  func toRaw(_ hit: Record) -> [String: Any]? {
    guard let json = try? JSON(hit) else { return nil }
    return [String: Any](json)
  }

  func cast<R: Decodable>(_ hit: Record) throws -> R {
    if let castedHit = hit as? R {
      return castedHit
    } else {
      throw Error.incompatibleRecordType
    }
  }

}

public extension HitsInteractor where Record == JSON {

  func rawHitForRow(_ row: Int) -> [String: Any]? {
    return hit(atIndex: row).flatMap([String: Any].init)
  }

}

extension HitsInteractor {

  public struct Settings {

    public var infiniteScrolling: InfiniteScrolling
    public var showItemsOnEmptyQuery: Bool

    public init(infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery) {
      self.infiniteScrolling = infiniteScrolling
      self.showItemsOnEmptyQuery = showItemsOnEmptyQuery
    }

  }

}

public enum InfiniteScrolling: Equatable {
  case on(withOffset: Int)
  case off
}

extension HitsInteractor: ResultUpdatable {

  @discardableResult public func update(_ searchResults: Result) -> Operation {
    let stats = searchResults.searchStats
    let updateOperation = BlockOperation { [weak self] in
      guard let hitsInteractor = self else { return }
      if case .on = hitsInteractor.settings.infiniteScrolling {
        hitsInteractor.infiniteScrollingController.notifyPending(pageIndex: stats.page)
        hitsInteractor.infiniteScrollingController.lastPageIndex = stats.pagesCount - 1
      }
      hitsInteractor.isLastQueryEmpty = stats.query.isNilOrEmpty

      do {
        let page: HitsPage<Record> = try HitsPage(searchResults: searchResults)
        hitsInteractor.paginator.process(page)
        hitsInteractor.onResultsUpdated.fire(searchResults)
      } catch let error {
        InstantSearchCoreLogger.HitsDecoding.failure(hitsInteractor: hitsInteractor, error: error)
        hitsInteractor.onError.fire(error)
      }
    }

    mutationQueue.addOperation(updateOperation)

    return updateOperation

  }

  public func notifyQueryChanged() {

    mutationQueue.cancelAllOperations()

    let queryChangedCompletion = { [weak self] in
      guard let hitsInteractor = self else { return }
      if case .on = hitsInteractor.settings.infiniteScrolling {
        hitsInteractor.infiniteScrollingController.notifyPendingAll()
      }

      hitsInteractor.paginator.invalidate()
      hitsInteractor.onRequestChanged.fire(())
    }

    mutationQueue.addOperation(queryChangedCompletion)

  }

  public func process(_ error: Swift.Error, for query: Query) {
    if let pendingPage = query.page {
      infiniteScrollingController.notifyPending(pageIndex: Int(pendingPage))
    }
  }

}

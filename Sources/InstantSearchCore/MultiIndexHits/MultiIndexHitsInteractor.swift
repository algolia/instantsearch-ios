//
//  MultiIndexHitsInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 15/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
/**
 Interactor which constitutes the aggregation of nested hits interactors providing a convenient functions for managing them.
 Designed for a joint usage with multi index searcher, but can be used with multiple separate single index searchers as well.
 */
@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public class MultiIndexHitsInteractor {

  public let onRequestChanged: Observer<Void>
  public let onResultsUpdated: Observer<[SearchResponse]>
  public let onError: Observer<Swift.Error>

  private let mutationQueue: OperationQueue

  /// List of nested hits interactors

  let hitsInteractors: [AnyHitsInteractor]

  /// Common initializer

  public init(hitsInteractors: [AnyHitsInteractor]) {
    self.hitsInteractors = hitsInteractors
    self.onRequestChanged = .init()
    self.onResultsUpdated = .init()
    self.onError = .init()
    self.mutationQueue = .init()
    self.mutationQueue.maxConcurrentOperationCount = 1
    self.mutationQueue.qualityOfService = .userInitiated
    for interactor in hitsInteractors {
      interactor.onError.subscribe(with: self) { multIndexInteractor, error in
        InstantSearchCoreLogger.HitsDecoding.failure(hitsInteractor: interactor, error: error)
        multIndexInteractor.onError.fire(error)
      }
    }
  }

  /// Returns the index of provided hits interactor.
  /// - Parameter hitsInteractor: the interactor to search for
  /// - Returns: The index of desired interactor. If no there is no such interactor, returns `nil`

  public func section<R>(of hitsInteractor: HitsInteractor<R>) -> Int? {
    return hitsInteractors.firstIndex { ($0 as? HitsInteractor<R>) === hitsInteractor }
  }

  /// Returns boolean value indicating if desired hitsInteractor is nested in current multi hits hitsInteractor
  /// - Parameter hitsInteractor: the interactor to check

  public func contains<R>(_ hitsInteractor: HitsInteractor<R>) -> Bool {
    return section(of: hitsInteractor) != nil
  }

  /// Returns a hits interactor at specified index
  /// - Parameter section: the section index of nested hits interactor
  /// - Throws: HitsInteractor.Error.incompatibleRecordType if the derived record type mismatches the record type of corresponding hits interactor
  /// - Returns: The nested interactor at specified index.

  public func hitsInteractor<R>(forSection section: Int) throws -> HitsInteractor<R> {
    guard let typedInteractor = hitsInteractors[section] as? HitsInteractor<R> else {
      throw HitsInteractor<R>.Error.incompatibleRecordType
    }

    return typedInteractor
  }

  /// Returns the hit of a desired type
  /// - Parameter index: the index of a hit in a nested hits Interactor
  /// - Parameter section: the index of a nested hits Interactor
  /// - Throws: HitsInteractor.Error.incompatibleRecordType if desired type of record doesn't match with record type of corresponding hits Interactor
  /// - Returns: The hit at row for index path or `nil` if there is no element at index in a specified section

  public func hit<R: Codable>(atIndex index: Int, inSection section: Int) throws -> R? {
    return try hitsInteractors[section].genericHitAtIndex(index)
  }

  /// Returns the hit in raw dictionary form
  /// - Parameter index: the index of a hit in a nested hits Interactor
  /// - Parameter section: the index of a nested hits Interactor
  /// - Returns: The hit in raw dictionary form or `nil` if there is no element at index in a specified section

  public func rawHit(atIndex index: Int, inSection section: Int) -> [String: Any]? {
    return hitsInteractors[section].rawHitAtIndex(index)
  }

  /// Returns number of nested hits Interactors

  public func numberOfSections() -> Int {
    return hitsInteractors.count
  }

  /// Returns number rows in the nested hits Interactor at section
  /// - Parameter section: the index of nested hits Interactor
  public func numberOfHits(inSection section: Int) -> Int {
    return hitsInteractors[section].numberOfHits()
  }

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
extension MultiIndexHitsInteractor {

  /// Updates the results of a nested hits Interactor at specified index
  /// - Parameter results: list of typed search results.
  /// - Parameter section: the section index of nested hits Interactor
  /// - Throws: HitsInteractor.Error.incompatibleRecordType if the record type of results mismatches the record type of corresponding hits Interactor

  public func update(_ results: SearchResponse, forInteractorInSection section: Int) {

    let completion = BlockOperation { [weak self] in
      self?.onResultsUpdated.fire([results])
    }

    completion.addDependency(hitsInteractors[section].update(results))

    mutationQueue.addOperation(completion)

  }

  /// Updates the results of all nested hits Interactors.
  /// Each search results element will be converted to a corresponding nested hits Interactor search results type.
  /// - Parameter results: list of generic search results. Order of results must match the order of nested hits Interactors.
  /// - Parameter metadata: the metadata of query corresponding to results
  /// - Throws: HitsInteractor.Error.incompatibleRecordType if the conversion of search results for one of a nested hits Interactors is impossible due to a record type mismatch

  public func update(_ results: [SearchResponse]) {

    let completion = BlockOperation { [weak self] in
      self?.onResultsUpdated.fire(results)
    }

    zip(hitsInteractors, results).map { arg in
      let (interactor, results) = arg
      return interactor.update(results)
    }.forEach(completion.addDependency)

    mutationQueue.addOperation(completion)

  }

  public func process(_ error: Error, for queries: [Query]) {
    zip(hitsInteractors, queries).forEach { (hitsInteractor, query) in
      hitsInteractor.process(error, for: query)
    }
  }

  public func notifyQueryChanged() {
    hitsInteractors.forEach {
      $0.notifyQueryChanged()
    }
    onRequestChanged.fire(())
  }

}

#if os(iOS) || os(tvOS)
import UIKit

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  /// Returns the hit of a desired type
  /// - Parameter indexPath: the pointer to a hit, where section points to a nested hits Interactor, and item defines the index of a hit in a Interactor
  /// - Throws: HitsInteractor.Error.incompatibleRecordType if desired type of record doesn't match with record type of corresponding hits Interactor
  /// - Returns: The hit at row for index path or `nil` if there is no element at index in a specified section

  func hit<R: Codable>(at indexPath: IndexPath) throws -> R? {
    return try hit(atIndex: indexPath.item, inSection: indexPath.section)
  }

  /// Returns the hit in raw dictionary form
  /// - Parameter indexPath: the pointer to a hit, where section points to a nested hits Interactor, and item defines the index of a hit in a Interactor
  /// - Returns: The hit in raw dictionary form or `nil` if there is no element at index in a specified section

  func rawHit(at indexPath: IndexPath) -> [String: Any]? {
    return rawHit(atIndex: indexPath.item, inSection: indexPath.section)
  }

}
#endif

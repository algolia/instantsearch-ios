//
//  PlacesSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

public class PlacesSearcher: Searcher, SequencerDelegate, SearchResultObservable {

  public var query: String? {

    get {
      return placesQuery.query
    }

    set {
      let oldValue = placesQuery.query
      guard oldValue != newValue else { return }
      placesQuery.query = newValue
      onQueryChanged.fire(newValue)
    }

  }

  public var placesQuery: PlacesQuery

  public let isLoading: Observer<Bool>

  public var onQueryChanged: Observer<String?>

  public let onSearch: Observer<Void>

  public let onResults: Observer<PlacesClient.SingleLanguageResponse>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query text and error
  public let onError: Observer<(String, Error)>

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  internal let placesClient: PlacesClient

  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          query: PlacesQuery = .init()) {
    let client = PlacesClient(appID: appID, apiKey: apiKey)
    self.init(client: client, query: query)
  }

  public init(client: PlacesClient, query: PlacesQuery = .init()) {
    self.placesClient = client
    self.placesQuery = query
    self.isLoading = .init()
    self.onQueryChanged = .init()
    self.onResults = .init()
    self.onError = .init()
    self.onSearch = .init()
    self.sequencer = .init()
    updateClientUserAgents()
    sequencer.delegate = self
    onResults.retainLastData = true
    isLoading.retainLastData = true
  }

  public func search() {

    onSearch.fire(())

    let operation = placesClient.search(query: placesQuery, language: .english) { [weak self] result in
      guard let searcher = self else { return }

      switch result {
      case .success(let results):
        InstantSearchCoreLogger.Results.success(searcher: searcher, indexName: "Algolia Places", results: results)
        searcher.onResults.fire(results)

      case .failure(let error):
        let query = searcher.placesQuery.query ?? ""
        InstantSearchCoreLogger.Results.failure(searcher: searcher, indexName: "Algolia Places", error)
        searcher.onError.fire((query, error))
      }
    }

    sequencer.orderOperation {
      return operation
    }

  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }

}

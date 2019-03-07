//
//  Searchers.swift
//  InstantSearch
//
//  Created by Guy Daher on 25/02/2019.
//

import Foundation
import Signals

public protocol SearcherV2 {
  func search()
  func cancel()
  func setQuery(text: String)
  var sequencer: Sequencer { get }
}

extension SearcherV2 {

  public func cancel() {
    sequencer.cancelPendingOperations()
  }

  public func serializeToSearchResults(content: [String: Any]?, error: Error?, disjunctiveFacets: [String]) -> Result<SearchResults> {
    if let error = error {
      return Result(error: error)
    }

    do {
      // TODO: Use what the new SearchResults of Vlad
      let searchResults = try SearchResults(content: content!, disjunctiveFacets: disjunctiveFacets)

      return Result(value: searchResults)
    } catch let error {
      return Result(error: error)
    }
  }
}

// TODO: don t forget to add RequestOption everywhere

public class SingleIndexSearcher: SearcherV2 {

  public let sequencer: Sequencer

  var index: Index
  var query: Query

  let onSearchResults = Signal<Result<SearchResults>>()

  public var applyDisjunctiveFacetingWhenNecessary = true

  public init(index: Index, query: Query) {
    self.index = index
    self.query = query
    sequencer = Sequencer()

  }

  public func setQuery(text: String) {
    self.query.query = text
  }

  public func search() {

    sequencer.orderOperation {

      if applyDisjunctiveFacetingWhenNecessary && query.filterBuilder.isDisjunctiveFacetingAvailable() {
        let disjunctiveFacets = Array(query.filterBuilder.getDisjunctiveFacetsAttributes()).map { $0.description }
        let refinements = query.filterBuilder.getRawFacetFilters()

        return self.index.searchDisjunctiveFaceting(query, disjunctiveFacets: disjunctiveFacets, refinements: refinements) { (content, error) in
          let result = self.serializeToSearchResults(content: content, error: error, disjunctiveFacets: disjunctiveFacets)
          self.onSearchResults.fire(result)
        }

      } else {
        return self.index.search(query) { (content, error) in
          let result = self.serializeToSearchResults(content: content, error: error, disjunctiveFacets: [])
          self.onSearchResults.fire(result)
        }
      }
    }
  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }
}


public class MultiIndexSearcher: SearcherV2 {

  let indexQueries: [IndexQuery]
  let client: Client
  public let sequencer: Sequencer

  var onSearchResults = Signal<[Result<SearchResults>]>()

  public var applyDisjunctiveFacetingWhenNecessary = true

  public convenience init(client: Client, indices: [Index], queries: [Query]) {
    self.init(client: client, indexQueries: zip(indices, queries).map { IndexQuery(index: $0, query: $1) } )
  }

  public convenience init(client: Client, indices: [Index], query: Query) {
    self.init(client: client, indexQueries: indices.map { IndexQuery(index: $0, query: query) })
  }

  public init(client: Client, indexQueries: [IndexQuery]) {
    self.indexQueries = indexQueries
    self.client = client
    self.sequencer = Sequencer()
  }

  public func setQuery(text: String) {
    self.indexQueries.forEach { $0.query.query = text }
  }

  public func search() {
    sequencer.orderOperation {
      self.client.multipleQueries(indexQueries) { (content, error) in
        var results: [Result<SearchResults>]
        if let content = content, let contentResults = content["results"] as? [[String: Any]] {
          results = contentResults.map { self.serializeToSearchResults(content: $0, error: error, disjunctiveFacets: []) }

        } else {
          // Here error should be non-nil, and anyways content is not a valid SearchResults since it's supposed to be a [SearchResults], so it will throw an error
          results = Array(repeating: self.serializeToSearchResults(content: content, error: error, disjunctiveFacets: []), count: self.indexQueries.count)
        } 
        self.onSearchResults.fire(results)
      }
    }
  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }
}

public class SearchForFacetValueSearcher: SearcherV2 {

  public let index: Index
  public let query: Query
  public var facetName: String
  public var text: String
  public let sequencer: Sequencer
  let onSearchResults = Signal<Result<[String: Any]>>()

  public init(index: Index, query: Query, facetName: String, text: String) {
    self.index = index
    self.query = query
    self.facetName = facetName
    self.text = text
    self.sequencer = Sequencer()
  }

  public func setQuery(text: String) {
    self.text = text
  }

  public func search() {
    sequencer.orderOperation {
      self.index.searchForFacetValues(of: facetName, matching: text) { (content, error) in
        if let error = error {
          self.onSearchResults.fire(Result(error: error))
        } else if let content = content {
          self.onSearchResults.fire(Result(value: content))
        }
      }
    }
  }
}

// Factory class creating those different kind of MultiIndexSearcher

public class SearcherFactory {

  public enum SearcherType {
    case singleIndex(Index, Query)
    case multipleIndex(Client, [IndexQuery])
    case searchForFacetValue(Index, Query, String, String)
  }

  static public func createSearcher(searcherType: SearcherType) -> SearcherV2 {
    switch searcherType {
    case .singleIndex(let index, let query):
      return SingleIndexSearcher(index: index, query: query)
    case .multipleIndex(let client, let indexQueries):
      return MultiIndexSearcher(client: client, indexQueries: indexQueries)
    case .searchForFacetValue(let index, let query, let facetName, let text):
      return SearchForFacetValueSearcher(index: index, query: query, facetName: facetName, text: text)
    }
  }
}

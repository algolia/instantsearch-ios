//
//  Searchers.swift
//  InstantSearch
//
//  Created by Guy Daher on 25/02/2019.
//

import Foundation

public protocol SearcherV2 {
  // TODO: AssociatedType
  func search()
  func cancel()
}

extension SearcherV2 {
  public func serializeToSearchResults(content: [String: Any]?, error: Error?, disjunctiveFacets: [String]) -> Result<SearchResults> {
    if let error = error {
      return Result(error: error)
    }

    do {
      // TODO: Also can modify SearchResulys to make it more modern with codable?
      let searchResults = try SearchResults(content: content!, disjunctiveFacets: disjunctiveFacets)

      return Result(value: searchResults)
    } catch let error {
      return Result(error: error)
    }
  }
}

// TODO: don t forget to add RequestOption everywhere

public typealias SearchResultHandler = (_ result: Result<SearchResults>) -> Void
public typealias MultiSearchResultHandler = (_ result: Result<[SearchResults]>) -> Void

public class SingleIndexSearcher: SearcherV2 {

  let sequencer: Sequencer

  var index: Index
  var query: Query

  var searchResultHandlers = [SearchResultHandler]()

  public var applyDisjunctiveFacetingWhenNecessary = true

  public init(index: Index, query: Query) {
    self.index = index
    self.query = query
    sequencer = Sequencer()
  }

  public func search() {

    sequencer.orderOperation {

      if applyDisjunctiveFacetingWhenNecessary && query.filterBuilder.isDisjunctiveFacetingAvailable() {
        let disjunctiveFacets = Array(query.filterBuilder.getDisjunctiveFacetsAttributes()).map { $0.description }
        let refinements = query.filterBuilder.getRawFacetFilters()

        return self.index.searchDisjunctiveFaceting(query, disjunctiveFacets: disjunctiveFacets, refinements: refinements) { (content, error) in
          let result = self.serializeToSearchResults(content: content, error: error, disjunctiveFacets: disjunctiveFacets)
          self.searchResultHandlers.forEach { $0(result) }
        }

      } else {
        return self.index.search(query) { (content, error) in
          let result = self.serializeToSearchResults(content: content, error: error, disjunctiveFacets: [])
          self.searchResultHandlers.forEach { $0(result) }
        }
      }
    }
  }

  public func cancel() {
    sequencer.cancelPendingRequests()
  }

  public func subscribeToSearchResults(using closure: @escaping SearchResultHandler) {
    self.searchResultHandlers.append(closure)
  }
}


public class MultiIndexSearcher: SearcherV2 {

  let indexQueries: [IndexQuery]
  let client: Client

  var searchResultHandlers = [MultiSearchResultHandler]()

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
  }

  public func search() {
    self.client.multipleQueries(indexQueries) { (content, error) in
      // convert content + error to [Result<SearchResults>]
//      var results:
//      let indicesResults = content as?
//      self.searchResultHandlers.forEach { $0(results) }
    }
  }

  public func cancel() {

  }

  public func subscribeToSearchResults(using closure: @escaping MultiSearchResultHandler) {
    self.searchResultHandlers.append(closure)
  }
}

// Factory class creating those different kind of MultiIndexSearcher

public class SearchForFacetValueSearcher: SearcherV2 {

  public let index: Index
  public let query: Query
  public var facetName: String
  public var text: String

  public init(index: Index, query: Query, facetName: String, text: String) {
    self.index = index
    self.query = query
    self.facetName = facetName
    self.text = text
  }

  // DISCSUSSION: A bit weird not having the text and facetName as param, but it's to respect the new Searcher protocol
  public func search() {
    self.index.searchForFacetValues(of: facetName, matching: text) { (_, _) in

    }
  }

  public func cancel() {

  }
}

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

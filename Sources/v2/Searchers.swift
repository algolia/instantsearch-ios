//
//  Searchers.swift
//  InstantSearch
//
//  Created by Guy Daher on 25/02/2019.
//

import Foundation

public protocol SearcherV2 {
  func search()
  func cancel()
}

// TODO: don t forget to add RequestOption everywhere

public typealias SearchResultHandler = (_ result: Result<SearchResults>) -> Void
public typealias MultiSearchResultHandler = (_ result: [Result<SearchResults>]) -> Void

public class SingleIndexSearcher: SearcherV2 {

  let index: Index
  let query: Query

  var searchResultHandlers = [SearchResultHandler]()

  public var applyDisjunctiveFacetingWhenNecessary = true

  public init(index: Index, query: Query) {
    self.index = index
    self.query = query
  }

  public func search() {
    // if index has disjunctive faceting
    if applyDisjunctiveFacetingWhenNecessary && true {
      self.index.searchDisjunctiveFaceting(query, disjunctiveFacets: [], refinements: [:]) { (content, _) in
        // convert content + error to Result<SearchResults>
        let result = try? SearchResults(content: content!, disjunctiveFacets: []) // TODO: Get disjunctive facets from filterbuilder
        // TODO: Also can modify SearchResulys to make it more modern with codable?
        self.searchResultHandlers.forEach { $0(Result(value: result!)) }
      }
    } else {
      self.index.search(query) { (content, _) in
        // convert content + error to Result<SearchResults>
        let result = try? SearchResults(content: content!, disjunctiveFacets: []) // TODO: Get disjunctive facets from filterbuilder
        // TODO: Also can modify SearchResulys to make it more modern with codable?
        self.searchResultHandlers.forEach { $0(Result(value: result!)) }
      }
    }
  }

  public func cancel() {

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

  public init(client: Client, indexQueries: [IndexQuery]) {
    self.indexQueries = indexQueries
    self.client = client
  }

  public func search() {
    self.client.multipleQueries(indexQueries) { (result, error) in
      // convert content + error to [Result<SearchResults>]
      // // then call all searchResultHandlers
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

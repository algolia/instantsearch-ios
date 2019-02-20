//
//  SearchViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 20/02/2019.
//

import Foundation
import InstantSearchCore

public typealias ResultHandler = (_ result: Result<SearchResults>, _ userInfo: [String: Any]) -> Void

public protocol SearchViewModelDelegate {
  func search(index: Searchable, _ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping ResultHandler)
  //func searchDisjunctiveFaceting // We don't need this one as the search above can check whether the query needs to do a disjunctive faceting or not.
  func searchForFacetValues(index: Searchable, of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping ResultHandler)

  func multipleQueries(_ queries: [IndexQuery], strategy: String?, requestOptions: RequestOptions?, completionHandler: @escaping ResultHandler)
}

class SearchViewModelV2: SearchViewModelDelegate {
  //let sequencer: Sequencer
  //let requestStrategy: RequestStrategy
  // let searchEvents: SearchEvents

  // TODO: Initial Sequencer with the global one once we create that class.
//  init(sequencer: Sequencer, requestStrategy: RequestStrategy) {
//    self.sequencer = sequencer
//    self.requestStrategy = requestStrategy
//  }

  func search(index: Searchable, _ query: Query, requestOptions: RequestOptions? = nil, completionHandler: @escaping ResultHandler) {

  }
  //func searchDisjunctiveFaceting // We don't need this one as the search above can check whether the query needs to do a disjunctive faceting or not.
  func searchForFacetValues(index: Searchable, of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions? = nil, completionHandler: @escaping ResultHandler) {

  }

  func multipleQueries(_ queries: [IndexQuery], strategy: String?, requestOptions: RequestOptions? = nil, completionHandler: @escaping ResultHandler) {

  }
}

protocol Sequencer {
  func cancelPendingRequests()

  func hasPendingRequests()

  var maxPendingRequests: Int { get set }
}

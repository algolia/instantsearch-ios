//
//  FacetSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// An entity performing facet values search 
final public class FacetSearcher: IndexSearcher<FacetSearchService> {

  public var client: SearchClient {
    return service.client
  }

  /// Current tuple of index and query
  public var indexQueryState: IndexQueryState {
    get {
      return .init(indexName: request.indexName, query: request.context)
    }

    set {
      request.indexName = newValue.indexName
      request.context = newValue.query
    }
  }

  /// Name of facet attribute for which the values will be searched
  public var facetName: String {
    get {
      request.attribute.rawValue
    }

    set {
      request.attribute = Attribute(rawValue: newValue)
    }
  }

  /// Custom request options
  public var requestOptions: RequestOptions? {
    get {
      request.requestOptions
    }

    set {
      request.requestOptions = newValue
    }
  }

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexName: Name of the index in which search will be performed
   - facetName: Name of facet attribute for which the values will be searched
   - query: Instance of Query. By default a new empty instant of Query will be created.
   - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          indexName: IndexName,
                          facetName: Attribute,
                          query: Query = .init(),
                          requestOptions: RequestOptions? = nil) {
    let service = FacetSearchService(client: .init(appID: appID, apiKey: apiKey))
    let request = Request(query: "", indexName: indexName, attribute: facetName, context: query, requestOptions: requestOptions)
    self.init(service: service, initialRequest: request)
  }

  public convenience init(client: SearchClient,
                          indexName: IndexName,
                          facetName: Attribute,
                          query: Query = .init(),
                          requestOptions: RequestOptions? = nil) {
    let service = FacetSearchService(client: client)
    let request = Request(query: "", indexName: indexName, attribute: facetName, context: query, requestOptions: requestOptions)
    self.init(service: service, initialRequest: request)
  }

}

extension FacetSearcher: MultiQueryCollectable {
  
  public func collect() -> (queries: [IndexedQuery], completion: (Swift.Result<[MultiIndexSearchResponse.Response], Swift.Error>) -> Void) {
    let query = IndexedQuery(indexName: request.indexName, query: request.context, attribute: request.attribute, facetQuery: request.query)
    return ([query], { [weak self] result in
      guard let searcher = self else { return }
      switch result {
      case .failure(let error):
        searcher.onError.fire(error)
      case .success(let responses):
        if let response = responses.first?.facetResponse {
          searcher.onResults.fire(response)
        }
      }
    })
  }
  
}

extension FacetSearcher: QuerySettable {
  
  public func setQuery(_ query: String?) {
    request.query = query ?? ""
    search()
  }
  
}

extension FacetSearcher: IndexNameSettable {
  
  public func setIndexName(_ indexName: IndexName) {
    request.indexName = indexName
    search()
  }
  
}

extension FacetSearcher: FiltersSettable {
  
  public func setFilters(_ filters: String?) {
    request.context.filters = filters
    search()
  }
  
}

//
//  FacetSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Core
import Foundation
import Search

/// An entity performing facet values search
public final class FacetSearcher: IndexSearcher<FacetSearchService> {
  public var client: SearchClient {
    return service.client
  }

  /// Current tuple of index and query
  @available(*, deprecated, message: "Use the `request` property instead")
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
      request.attribute
    }

    set {
      request.attribute = newValue
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
  public convenience init(appID: String,
                          apiKey: String,
                          indexName: String,
                          facetName: String,
                          query: SearchSearchParamsObject = .init(),
                          requestOptions: RequestOptions? = nil) throws {
    let service = FacetSearchService(client: try SearchClient(appID: appID, apiKey: apiKey))
    let request = Request(query: "", indexName: indexName, attribute: facetName, context: query, requestOptions: requestOptions)
    self.init(service: service, initialRequest: request)
    Telemetry.shared.trace(type: .facetSearcher,
                           parameters: [
                             .appID,
                             .apiKey
                           ])
  }

  public convenience init(client: SearchClient,
                          indexName: String,
                          facetName: String,
                          query: SearchSearchParamsObject = .init(),
                          requestOptions: RequestOptions? = nil) {
    let service = FacetSearchService(client: client)
    let request = Request(query: "", indexName: indexName, attribute: facetName, context: query, requestOptions: requestOptions)
    self.init(service: service, initialRequest: request)
    Telemetry.shared.trace(type: .facetSearcher,
                           parameters: [
                             .client
                           ])
  }
}

extension FacetSearcher: MultiSearchComponent {
  public typealias SubRequest = SearchQuery
  public typealias SubResult = Search.SearchResult<Hit<[String: AnyCodable]>>

  public func collect() -> (requests: [SearchQuery], completion: (Swift.Result<[Search.SearchResult<Hit<[String: AnyCodable]>>], Swift.Error>) -> Void) {
    let params = SearchParamsEncoder.encode(request.context)
    let query = SearchForFacets(params: params,
                                facet: request.attribute,
                                indexName: request.indexName,
                                facetQuery: request.query,
                                type: .facet)
    return ([SearchQuery.searchForFacets(query)], { [weak self] result in
      guard let searcher = self else { return }
      switch result {
      case let .failure(error):
        searcher.onError.fire(error)
      case let .success(responses):
        guard let response = responses.first else { return }
        switch response {
        case let .searchForFacetValuesResponse(facetResponse):
          searcher.onResults.fire(facetResponse)
        case .searchResponse:
          break
        }
      }
    })
  }
}

extension FacetSearcher: QuerySettable {
  public func setQuery(_ query: String?) {
    request.query = query ?? ""
  }
}

extension FacetSearcher: IndexNameSettable {
  public func setIndexName(_ indexName: String) {
    request.indexName = indexName
  }
}

extension FacetSearcher: FiltersSettable {
  public func setFilters(_ filters: String?) {
    request.context.filters = filters
  }
}

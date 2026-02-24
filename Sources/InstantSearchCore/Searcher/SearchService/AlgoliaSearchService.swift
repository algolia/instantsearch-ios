//
//  AlgoliaSearchService.swift
//
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Core
import Foundation
import Search

public class AlgoliaSearchService: SearchService {
  public let client: SearchClient

  /// Flag defining if disjunctive faceting is enabled
  /// - Default value: true
  public var isDisjunctiveFacetingEnabled = true

  /// Flag defining if the selected query facet must be kept even if it does not match current results anymore
  /// - Default value: true
  public var keepSelectedEmptyFacets: Bool = true

  /// Delegate providing a necessary information for disjuncitve faceting
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate?

  /// Delegate providing a necessary information for hierarchical faceting
  public weak var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate?

  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with disjunctiveFacetsAttributes provided by DisjunctiveFacetingDelegate to create the necessary queries for disjunctive faceting
  public var disjunctiveFacetsAttributes: Set<String>

  public init(client: SearchClient) {
    self.client = client
    disjunctiveFacetsAttributes = []
  }

  public func search(_ request: Request, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Operation {
    let operation = TaskAsyncOperation { [weak self] in
      guard let self else { return }
      do {
        if self.isDisjunctiveFacetingEnabled {
          let (queries, multiCompletion) = self.collect(for: request, completion: completion)
          let response: SearchResponses<SearchHit> = try await self.client.search(
            searchMethodParams: SearchMethodParams(queries: queries, strategy: request.strategy),
            requestOptions: request.requestOptions
          )
          multiCompletion(.success(response.results))
        } else {
          let response: SearchResponse = try await self.client.searchSingleIndex(
            indexName: request.indexName,
            searchParams: .searchSearchParamsObject(request.query),
            requestOptions: request.requestOptions
          )
          completion(.success(response))
        }
      } catch {
        completion(.failure(error))
      }
    }
    operation.start()
    return operation
  }
}

extension AlgoliaSearchService {
  func collect(for request: Request,
               completion: @escaping (Swift.Result<SearchResponse, Error>) -> Void) -> (requests: [SearchQuery], completion: (Swift.Result<[SearchResult<SearchHit>], Error>) -> Void) {
    let queries: [IndexedQuery]
    let transform: ([SearchResult<SearchHit>]) throws -> SearchResponse
    if isDisjunctiveFacetingEnabled {
      let filterGroups = disjunctiveFacetingDelegate?.toFilterGroups() ?? []
      let hierarchicalAttributes = hierarchicalFacetingDelegate?.hierarchicalAttributes ?? []
      let hierarchicalFilters = hierarchicalFacetingDelegate?.hierarchicalFilters ?? []
      var queriesBuilder = QueryBuilder(query: request.query,
                                        disjunctiveFacets: disjunctiveFacetsAttributes,
                                        filterGroups: filterGroups,
                                        hierarchicalAttributes: hierarchicalAttributes,
                                        hierachicalFilters: hierarchicalFilters)
      queriesBuilder.keepSelectedEmptyFacets = keepSelectedEmptyFacets
      queries = queriesBuilder.build().map { IndexedQuery(indexName: request.indexName, query: $0) }
      transform = { results in
        let responses = try results.map { result -> SearchResponse in
          switch result {
          case let .searchResponse(response):
            return response
          case .searchForFacetValuesResponse:
            throw MultiSearchError.unexpectedFacetResponse
          }
        }
        return try queriesBuilder.aggregate(responses)
      }
    } else {
      queries = [IndexedQuery(indexName: request.indexName, query: request.query)]
      transform = { results in
        guard let first = results.first else {
          throw MultiSearchError.emptyResults
        }
        switch first {
        case let .searchResponse(response):
          return response
        case .searchForFacetValuesResponse:
          throw MultiSearchError.unexpectedFacetResponse
        }
      }
    }
    let searchQueries = queries.asSearchQueries()
    let multiCompletion: (Swift.Result<[SearchResult<SearchHit>], Error>) -> Void = { result in
      switch result {
      case let .success(results):
        do {
          completion(.success(try transform(results)))
        } catch {
          completion(.failure(error))
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
    return (searchQueries, multiCompletion)
  }
}

public extension AlgoliaSearchService {
  struct Request: IndexNameProvider, TextualQueryProvider, AlgoliaRequest {
    public var indexName: String
    public var query: SearchSearchParamsObject
    public var requestOptions: RequestOptions?
    public var strategy: MultipleQueriesStrategy?

    public var textualQuery: String? {
      get {
        query.query
      }
      set {
        query.query = newValue
      }
    }

    public init(indexName: String,
                query: SearchSearchParamsObject,
                requestOptions: RequestOptions? = nil,
                strategy: MultipleQueriesStrategy? = nil) {
      self.indexName = indexName
      self.query = query
      self.requestOptions = requestOptions
      self.strategy = strategy
    }
  }
}

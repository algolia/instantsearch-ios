//
//  CompositionSearchService.swift
//  InstantSearchCore
//

import AlgoliaComposition
import AlgoliaCore
import AlgoliaSearch
import Foundation

/// Search service performing search requests targeting the Algolia Composition API
/// (`/1/compositions/{compositionID}/run` endpoint).
///
/// The composition run response is mapped to a regular `SearchResponse` so that all
/// the existing connectors (hits, stats, facet list, ...) can be used with a `CompositionSearcher`.
public class CompositionSearchService: SearchService {
  public let client: CompositionClient

  /// Delegate providing the disjunctive facets attributes.
  ///
  /// Unlike index searches, the Composition API handles disjunctive faceting server-side:
  /// the requested facets matching these attributes are annotated with the `disjunctive` modifier.
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate?

  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with the attributes provided by the `disjunctiveFacetingDelegate`.
  public var disjunctiveFacetsAttributes: Set<String>

  public init(client: CompositionClient) {
    self.client = client
    disjunctiveFacetsAttributes = []
  }

  public func search(_ request: Request, completion: @escaping (Result<SearchResponse<SearchHit>, Error>) -> Void) -> Operation {
    let requestBody = AlgoliaComposition.RequestBody(params: annotatingDisjunctiveFacets(request.params),
                                                     feedsOrder: request.feedsOrder)
    let operation = TaskAsyncOperation { [weak self] in
      guard let self else { return }
      do {
        let response: CompositionSearchResponse<SearchHit> = try await self.client.search(
          compositionID: request.compositionID,
          requestBody: requestBody,
          requestOptions: request.requestOptions
        )
        guard let result = response.results.first else {
          throw CompositionSearchError.emptyResults
        }
        completion(.success(result.searchResponse))
      } catch {
        completion(.failure(error))
      }
    }
    operation.start()
    return operation
  }

  /// Annotates the requested facets with the `disjunctive` modifier for the attributes
  /// provided by the disjunctive faceting delegate and the manually set attributes.
  func annotatingDisjunctiveFacets(_ params: CompositionParams) -> CompositionParams {
    let disjunctiveAttributes = disjunctiveFacetsAttributes
      .union(disjunctiveFacetingDelegate?.disjunctiveFacetsAttributes ?? [])
    guard !disjunctiveAttributes.isEmpty, let facets = params.facets else {
      return params
    }
    var params = params
    params.facets = facets.map { attribute in
      disjunctiveAttributes.contains(attribute) ? "disjunctive(\(attribute))" : attribute
    }
    return params
  }
}

/// Error which can occur during a composition search
public enum CompositionSearchError: Error {
  /// The composition run response contains no results
  case emptyResults
}

public extension CompositionSearchService {
  struct Request: TextualQueryProvider, AlgoliaRequest {
    /// Unique Composition ObjectID
    public var compositionID: String

    /// Search parameters of the composition run request
    public var params: CompositionParams

    /// A list of feed IDs specifying the order of the results in the response (multifeed compositions only)
    public var feedsOrder: [String]?

    /// Custom request options
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get {
        params.query
      }
      set {
        params.query = newValue
      }
    }

    public init(compositionID: String,
                params: CompositionParams = .init(),
                feedsOrder: [String]? = nil,
                requestOptions: RequestOptions? = nil) {
      self.compositionID = compositionID
      self.params = params
      self.feedsOrder = feedsOrder
      self.requestOptions = requestOptions
    }
  }
}

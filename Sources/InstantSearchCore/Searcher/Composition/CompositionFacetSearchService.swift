//
//  CompositionFacetSearchService.swift
//  InstantSearchCore
//

import AlgoliaComposition
import AlgoliaCore
import AlgoliaSearch
import Foundation

/// Search service performing facet values search requests targeting the Algolia Composition API
/// (`/1/compositions/{compositionID}/facets/{facetName}/query` endpoint).
///
/// The composition facet values response is mapped to a regular `SearchForFacetValuesResponse`
/// so that all the existing components consuming facet search results can be reused.
public class CompositionFacetSearchService: SearchService {
  public let client: CompositionClient

  public init(client: CompositionClient) {
    self.client = client
  }

  public func search(_ request: Request, completion: @escaping (Result<SearchForFacetValuesResponse, Error>) -> Void) -> Operation {
    let operation = TaskAsyncOperation { [client] in
      do {
        let params = AlgoliaComposition.SearchForFacetValuesParams(query: request.query,
                                                                   maxFacetHits: request.maxFacetHits,
                                                                   searchQuery: request.context)
        let response = try await client.searchForFacetValues(
          compositionID: request.compositionID,
          facetName: request.attribute,
          searchForFacetValuesRequest: CompositionSearchForFacetValuesRequest(params: params),
          requestOptions: request.requestOptions
        )
        guard let result = response.results?.first else {
          throw CompositionSearchError.emptyResults
        }
        completion(.success(result.searchForFacetValuesResponse))
      } catch {
        completion(.failure(error))
      }
    }
    operation.start()
    return operation
  }
}

public extension CompositionFacetSearchService {
  struct Request: TextualQueryProvider, AlgoliaRequest {
    /// Facet query
    public var query: String

    /// Unique Composition ObjectID
    public var compositionID: String

    /// Name of the facet attribute for which the values will be searched
    public var attribute: String

    /// Search parameters narrowing down the facet values search
    public var context: CompositionParams

    /// Maximum number of facet values to return
    public var maxFacetHits: Int?

    /// Custom request options
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get {
        query
      }
      set {
        query = newValue ?? ""
      }
    }

    public init(query: String,
                compositionID: String,
                attribute: String,
                context: CompositionParams = .init(),
                maxFacetHits: Int? = nil,
                requestOptions: RequestOptions? = nil) {
      self.query = query
      self.compositionID = compositionID
      self.attribute = attribute
      self.context = context
      self.maxFacetHits = maxFacetHits
      self.requestOptions = requestOptions
    }
  }
}

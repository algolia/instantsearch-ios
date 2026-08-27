//
//  CompositionFacetSearcher.swift
//  InstantSearchCore
//

import AlgoliaComposition
import AlgoliaCore
import Foundation

/// An entity performing facet values search requests targeting an Algolia composition
/// (`/1/compositions/{compositionID}/facets/{facetName}/query` endpoint).
public final class CompositionFacetSearcher: AbstractSearcher<CompositionFacetSearchService> {
  public var client: CompositionClient {
    return service.client
  }

  /// Unique Composition ObjectID
  public var compositionID: String {
    get {
      request.compositionID
    }
    set {
      request.compositionID = newValue
    }
  }

  /// Name of the facet attribute for which the values will be searched
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
     - compositionID: Unique Composition ObjectID
     - facetName: Name of the facet attribute for which the values will be searched
     - params: Search parameters narrowing down the facet values search. By default a new empty instance of `CompositionParams` will be created.
     - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(appID: String,
                          apiKey: String,
                          compositionID: String,
                          facetName: String,
                          params: CompositionParams = .init(),
                          requestOptions: RequestOptions? = nil) throws {
    let client = try CompositionClient(appID: appID, apiKey: apiKey)
    self.init(client: client, compositionID: compositionID, facetName: facetName, params: params, requestOptions: requestOptions)
  }

  /**
   - Parameters:
     - client: Composition client instance
     - compositionID: Unique Composition ObjectID
     - facetName: Name of the facet attribute for which the values will be searched
     - params: Search parameters narrowing down the facet values search. By default a new empty instance of `CompositionParams` will be created.
     - requestOptions: Custom request options. Default is `nil`.
   */
  public init(client: CompositionClient,
              compositionID: String,
              facetName: String,
              params: CompositionParams = .init(),
              requestOptions: RequestOptions? = nil) {
    let service = CompositionFacetSearchService(client: client)
    let request = CompositionFacetSearchService.Request(query: "",
                                                        compositionID: compositionID,
                                                        attribute: facetName,
                                                        context: params,
                                                        requestOptions: requestOptions)
    super.init(service: service, initialRequest: request)
  }
}

extension CompositionFacetSearcher: QuerySettable {
  public func setQuery(_ query: String?) {
    request.query = query ?? ""
  }
}

extension CompositionFacetSearcher: FiltersSettable {
  public func setFilters(_ filters: String?) {
    request.context.filters = filters
  }
}

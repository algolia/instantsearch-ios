//
//  CompositionSearcher.swift
//  InstantSearchCore
//

@_exported import AlgoliaComposition
import AlgoliaCore
import Foundation

/// An entity performing search requests targeting an Algolia composition
/// (`/1/compositions/{compositionID}/run` endpoint).
///
/// The composition run response is presented as a regular `SearchResponse`, so a
/// `CompositionSearcher` can be connected to the same components as a `HitsSearcher`
/// (hits, stats, facet list, search box, filter state, infinite scrolling, ...).
///
/// Unlike `HitsSearcher`, disjunctive faceting is handled server-side by the Composition API:
/// the searcher annotates the requested facets with the `disjunctive` modifier instead of
/// performing a multi-query fan-out. A `CompositionSearcher` cannot join a `MultiSearcher`.
public final class CompositionSearcher: AbstractSearcher<CompositionSearchService> {
  /// Unique Composition ObjectID
  public var compositionID: String {
    get {
      request.compositionID
    }
    set {
      request.compositionID = newValue
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

  /// Delegate providing the disjunctive facets attributes annotated with the `disjunctive` modifier
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate? {
    get {
      service.disjunctiveFacetingDelegate
    }
    set {
      service.disjunctiveFacetingDelegate = newValue
    }
  }

  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with the attributes provided by the `disjunctiveFacetingDelegate`.
  public var disjunctiveFacetsAttributes: Set<String> {
    get {
      service.disjunctiveFacetsAttributes
    }
    set {
      service.disjunctiveFacetsAttributes = newValue
    }
  }

  override public var request: Request {
    didSet {
      guard request.params.query != oldValue.params.query || request.compositionID != oldValue.compositionID else { return }
      if request.params.page ?? 0 != 0 {
        request.params.page = 0
      }
    }
  }

  /**
    - Parameters:
       - appID: Application ID
       - apiKey: API Key
       - compositionID: Unique Composition ObjectID
       - params: Search parameters of the composition run request. By default a new empty instance of `CompositionParams` will be created.
       - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(appID: String,
                          apiKey: String,
                          compositionID: String,
                          params: CompositionParams = .init(),
                          requestOptions: RequestOptions? = nil) throws {
    let client = try CompositionClient(appID: appID, apiKey: apiKey)
    self.init(client: client, compositionID: compositionID, params: params, requestOptions: requestOptions)
  }

  /**
    - Parameters:
       - client: Composition client instance
       - compositionID: Unique Composition ObjectID
       - params: Search parameters of the composition run request. By default a new empty instance of `CompositionParams` will be created.
       - requestOptions: Custom request options. Default is `nil`.
   */
  public init(client: CompositionClient,
              compositionID: String,
              params: CompositionParams = .init(),
              requestOptions: RequestOptions? = nil) {
    let service = CompositionSearchService(client: client)
    let request = CompositionSearchService.Request(compositionID: compositionID,
                                                   params: params,
                                                   requestOptions: requestOptions)
    super.init(service: service, initialRequest: request)
  }
}

extension CompositionSearcher: QuerySettable {
  public func setQuery(_ query: String?) {
    request.params.query = query
    request.params.page = 0
  }
}

extension CompositionSearcher: FiltersSettable {
  public func setFilters(_ filters: String?) {
    request.params.filters = filters
    request.params.page = 0
  }
}

extension CompositionSearcher: PageLoadable {
  public func loadPage(atIndex pageIndex: Int) {
    request.params.page = pageIndex
    search()
  }
}

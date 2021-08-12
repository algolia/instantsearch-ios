//
//  CompositeSearcher.swift
//  
//
//  Created by Vladislav Fitc on 11/08/2021.
//

import Foundation


/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class CompositeSearcher<Service: SearchService, UnitQuery, UnitResponse> where Service.Request == [UnitQuery], Service.Result == [UnitResponse] {
  
  public let service: Service
  
  var searchers: [MultiQueryCollectableWrapper<UnitQuery, UnitResponse>]
  
  public init(service: Service) {
    self.searchers = []
    self.service = service
  }
  
}

extension CompositeSearcher: MultiQueryCollectable {
  
  public func collect() -> (queries: [UnitQuery], completion: (Result<[UnitResponse], Error>) -> Void) {
    let queriesAndCompletions = searchers.map { $0.collect() }
    
    let queries = queriesAndCompletions.map(\.queries)
    let completions = queriesAndCompletions.map(\.completion)
    
    /// Maps the nested lists to the ranges corresponding to the positions of the nested list elements in the flatten list
    /// Example: [["a", "b", "c"], ["d", "e"], ["f", "g", "h"]] -> [0..<3, 3..<5, 5..<8]
    func flatRanges<T>(_ list: [[T]]) -> [Range<Int>] {
      var ranges: [Range<Int>] = []
      var offset: Int = 0
      for sublist in list {
        let nextOffset = offset+sublist.count
        let range = offset..<nextOffset
        ranges.append(range)
        offset = nextOffset
      }
      return ranges
    }
    
    let rangePerCompletion = zip(completions, flatRanges(queries))

    return (queries.flatMap { $0 }, { result in
      for (completion, range) in rangePerCompletion {
        let resultForCompletion = result.map { Array($0[range]) }
        completion(resultForCompletion)
      }
    })
  }

}

extension CompositeSearcher: TextualQueryProvider {
  
  public var textualQuery: String? {
    get {
      return searchers.compactMap { $0 as? TextualQueryProvider }.first?.textualQuery
    }
    
    set {
      
    }
  }
  
}

extension CompositeSearcher: Searchable {
  
  public func search() {
    let (queries, completion) = collect()
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
  
}

extension CompositeSearcher where Service == SearchClient {
  
  convenience init(appID: ApplicationID, apiKey: APIKey) {
    self.init(service: .init(appID: appID, apiKey: apiKey))
  }
  
  @discardableResult public func addHitsSearcher(indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) -> SingleIndexSearcher {
    let searcher = SingleIndexSearcher(client: service, indexName: indexName, query: query, requestOptions: requestOptions)
    searchers.append(MultiQueryCollectableWrapper(wrapped: searcher))
    return searcher
  }
  
  @discardableResult public func addFacetsSearcher(indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) -> FacetSearcher {
    let searcher = FacetSearcher(client: service, indexName: indexName, facetName: attribute, query: query, requestOptions: requestOptions)
    searchers.append(MultiQueryCollectableWrapper(wrapped: searcher))
    return searcher
  }
  
  @discardableResult public func addSearcher<S: MultiQueryCollectable>(_ searcher: S) -> S where S.UnitQuery == IndexedQuery, S.UnitResponse == MultiIndexSearchResponse.Response {
    searchers.append(MultiQueryCollectableWrapper(wrapped: searcher))
    return searcher
  }

}

public protocol MultiQueryCollectable {
  
  associatedtype UnitQuery
  associatedtype UnitResponse
  
  /// Returns the list of queries and the completion that might be called with for the result of these queries
  func collect() -> (queries: [UnitQuery], completion: (Result<[UnitResponse], Error>) -> Void)
  
}

class MultiQueryCollectableWrapper<UnitQuery, UnitResponse>: MultiQueryCollectable {

  let wrapped: Any
  let collectClosure: () -> (queries: [UnitQuery], completion: (Result<[UnitResponse], Error>) -> Void)
  
  init<T: MultiQueryCollectable>(wrapped: T) where T.UnitQuery == UnitQuery, T.UnitResponse == UnitResponse {
    self.wrapped = wrapped
    self.collectClosure = wrapped.collect
  }
  
  func collect() -> (queries: [UnitQuery], completion: (Result<[UnitResponse], Error>) -> Void) {
    return collectClosure()
  }
  
}

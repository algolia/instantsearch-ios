//
//  AbstractCompositeSearcher.swift
//  
//
//  Created by Vladislav Fitc on 11/08/2021.
//

import Foundation

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class AbstractCompositeSearcher<Service: CompositeSearchService>: AbstractSearcher<Service> where Service.Process == Operation {

  public typealias SubRequest = Service.Request.SubRequest
  public typealias SubResult = Service.Result.SubResult

  /// List of wrapped sub-searchers
  internal var subSearchers: [AnySubSearcher<SubRequest, SubResult>] = []

  /// Add a child searcher
  /// - parameter child: child searcher to add
  @discardableResult public func addSearcher<S: SubSearcher>(_ child: S) -> S where S.SubRequest == SubRequest, S.SubResult == SubResult {
    subSearchers.append(AnySubSearcher(wrapped: child))
    return child
  }

  public override func search() {
    let (requests, completion) = collect()
    request.subRequests = requests
    onResults.subscribeOnce(with: self) { _, result in
      completion(.success(result.subResults))
    }
    onError.subscribeOnce(with: self) { _, error in
      completion(.failure(error))
    }
    super.search()
  }

}

extension AbstractCompositeSearcher: SubSearcher {

  public func collect() -> (requests: [SubRequest], completion: (Swift.Result<[SubResult], Error>) -> Void) {
    let requestsAndCompletions = subSearchers.map { $0.collect() }

    let requests = requestsAndCompletions.map(\.requests)
    let completions = requestsAndCompletions.map(\.completion)

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

    let rangePerCompletion = zip(completions, flatRanges(requests))

    return (requests.flatMap { $0 }, { result in
      for (completion, range) in rangePerCompletion {
        let resultForCompletion = result.map { Array($0[range]) }
        completion(resultForCompletion)
      }
    })
  }

}

extension AbstractCompositeSearcher: QuerySettable {

  public func setQuery(_ query: String?) {
    subSearchers
      .compactMap { $0.wrapped as? QuerySettable }
      .forEach {
        $0.setQuery(query)
      }
  }

}

extension AbstractCompositeSearcher: IndexNameSettable {

  public func setIndexName(_ indexName: IndexName) {
    subSearchers
      .compactMap { $0.wrapped as? IndexNameSettable }
      .forEach {
        $0.setIndexName(indexName)
      }
  }

}

extension AbstractCompositeSearcher: FiltersSettable {

  public func setFilters(_ filters: String?) {
    subSearchers
      .compactMap { $0.wrapped as? FiltersSettable }
      .forEach {
        $0.setFilters(filters)
      }
  }

}

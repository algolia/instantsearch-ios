//
//  AbstractMultiSearcher.swift
//
//
//  Created by Vladislav Fitc on 11/08/2021.
//

import Foundation

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class AbstractMultiSearcher<Service: MultiSearchService>: AbstractSearcher<Service> where Service.Process == Operation {
  public typealias SubRequest = Service.Request.SubRequest
  public typealias SubResult = Service.Result.SubResult

  /// List of wrapped sub-searchers
  internal var components: [AnyMultiSearchComponent<SubRequest, SubResult>] = []

  /// Add a child searcher
  /// - parameter child: child searcher to add
  @discardableResult public func addSearcher<S: MultiSearchComponent>(_ component: S) -> S where S.SubRequest == SubRequest, S.SubResult == SubResult {
    components.append(AnyMultiSearchComponent(wrapped: component))
    return component
  }

  override public func search() {
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

extension AbstractMultiSearcher: MultiSearchComponent {
  public func collect() -> (requests: [SubRequest], completion: (Swift.Result<[SubResult], Error>) -> Void) {
    let requestsAndCompletions = components.map { $0.collect() }

    let requests = requestsAndCompletions.map(\.requests)
    let completions = requestsAndCompletions.map(\.completion)
    let rangePerCompletion = zip(completions, requests.flatRanges())

    return (requests.flatMap { $0 }, { result in
      for (completion, range) in rangePerCompletion {
        switch result {
        case let .success(subresults):
          guard
            range.lowerBound <= subresults.endIndex,
            range.upperBound <= subresults.endIndex else {
            completion(.failure(MultiSearchError.resultsRangeMismatch(range, subresults.startIndex..<subresults.endIndex)))
            return
          }
          completion(.success(Array(subresults[range])))
        case let .failure(error):
          completion(.failure(MultiSearchError.serviceError(error)))
        }
      }
    })
  }
}

extension AbstractMultiSearcher: QuerySettable {
  public func setQuery(_ query: String?) {
    components
      .compactMap { $0.wrapped as? QuerySettable }
      .forEach {
        $0.setQuery(query)
      }
  }
}

extension AbstractMultiSearcher: IndexNameSettable {
  public func setIndexName(_ indexName: IndexName) {
    components
      .compactMap { $0.wrapped as? IndexNameSettable }
      .forEach {
        $0.setIndexName(indexName)
      }
  }
}

extension AbstractMultiSearcher: FiltersSettable {
  public func setFilters(_ filters: String?) {
    components
      .compactMap { $0.wrapped as? FiltersSettable }
      .forEach {
        $0.setFilters(filters)
      }
  }
}

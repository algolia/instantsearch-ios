//
//  CompositeSearcher.swift
//  
//
//  Created by Vladislav Fitc on 11/08/2021.
//

import Foundation

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class AbstractCompositeSearcher<Service: CompositeSearchService> where Service.Process == Operation {

  /// Service which performs search requests
  public let service: Service

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  internal var children: [AnyCompositeSearchSource<RequestUnit, ResultUnit>]

  public init(service: Service) {
    self.service = service
    self.sequencer = .init()
    self.children = []
  }

  @discardableResult public func addSearcher<S: CompositeSearchSource>(_ child: S) -> S where S.RequestUnit == RequestUnit, S.ResultUnit == ResultUnit {
    children.append(AnyCompositeSearchSource(wrapped: child))
    return child
  }

}

extension AbstractCompositeSearcher: CompositeSearchSource {

  public func collect() -> (queries: [Service.RequestUnit], completion: (Result<[Service.ResultUnit], Error>) -> Void) {
    let queriesAndCompletions = children.map { $0.collect() }

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

extension AbstractCompositeSearcher: Searchable {

  public func search() {
    let (queries, completion) = collect()
    let operation = service.search(queries, completion: completion)
    sequencer.orderOperation(operationLauncher: { return operation })
  }

}

extension AbstractCompositeSearcher: QuerySettable {

  public func setQuery(_ query: String?) {
    children
      .compactMap { $0.wrapped as? QuerySettable }
      .forEach {
        $0.setQuery(query)
      }
    search()
  }

}

extension AbstractCompositeSearcher: IndexNameSettable {

  public func setIndexName(_ indexName: IndexName) {
    children
      .compactMap { $0.wrapped as? IndexNameSettable }
      .forEach {
        $0.setIndexName(indexName)
      }
    search()
  }

}

extension AbstractCompositeSearcher: FiltersSettable {

  public func setFilters(_ filters: String?) {
    children
      .compactMap { $0.wrapped as? FiltersSettable }
      .forEach {
        $0.setFilters(filters)
      }
    search()
  }

}

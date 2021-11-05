//
//  SwitchIndexInteractor+Searcher.swift
//
//
//  Created by Vladislav Fitc on 08/04/2021.
//
import Foundation

@available(*, deprecated, message: "Use SortByInteractor instead")
public extension SwitchIndexInteractor {

  struct SearcherConnection<Service: SearchService>: Connection where Service.Process == Operation, Service.Request: IndexNameProvider {

    public let interactor: SwitchIndexInteractor
    public let searcher: IndexSearcher<Service>

    public func connect() {
      interactor.onSelectionChange.subscribe(with: searcher) { (_, selectedIndexName) in
        searcher.request.indexName = selectedIndexName
        searcher.search()
      }
    }

    public func disconnect() {
      interactor.onSelectionChange.cancelSubscription(for: searcher)
    }

  }

  @discardableResult func connectSearcher<Service: SearchService>(_ searcher: IndexSearcher<Service>) -> SearcherConnection<Service> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}

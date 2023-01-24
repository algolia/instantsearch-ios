//
//  IndexSearcher.swift
//
//
//  Created by Vladislav Fitc on 15/12/2020.
//

import Foundation

/// Abstract search service the request of which includes IndexName
open class IndexSearcher<Service: SearchService>: AbstractSearcher<Service> where Service.Process == Operation, Service.Request: IndexNameProvider {
  override public var request: Request {
    didSet {
      if request.indexName != oldValue.indexName {
        cancel()
        onIndexChanged.fire(request.indexName)
      }
    }
  }

  /// Triggered when an index name of request changed
  /// - Parameter: equals to a new index value
  public let onIndexChanged: Observer<IndexName>

  override public init(service: Service, initialRequest: Request) {
    onIndexChanged = .init()
    super.init(service: service, initialRequest: initialRequest)
  }
}

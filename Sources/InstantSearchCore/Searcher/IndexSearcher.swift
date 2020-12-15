//
//  IndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 15/12/2020.
//

import Foundation

public class IndexSearcher<Service: SearchService>: BaseSearcher<Service> where Service.Process == Operation, Service.Request: IndexNameProvider {
  
  public override var request: Request {
    didSet {
      if request.indexName != oldValue.indexName {
        onIndexChanged.fire(request.indexName)
      }
    }
  }

  /// Triggered when an index of Searcher changed
  /// - Parameter: equals to a new index value
  public let onIndexChanged: Observer<IndexName>
  
  public override init(service: Service, initialRequest: Request) {
    onIndexChanged = .init()
    super.init(service: service, initialRequest: initialRequest)
  }
  
}

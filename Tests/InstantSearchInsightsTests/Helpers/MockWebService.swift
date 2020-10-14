//
//  MockWS.swift
//  InsightsTests
//
//  Created by Robert Mogos on 07/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchInsights

class MockWebService: WebService {
  let stub: (Any) -> ()
  
  init(sessionConfig: URLSessionConfiguration, logger: Logger, stub: @escaping (Any) -> ()) {
    self.stub = stub
    super.init(sessionConfig: sessionConfig, logger: logger)
  }
  
  public override func load<A, E>(resource: Resource<A, E>, completion: @escaping (Result<A?, Error>) -> ()) {
    stub(resource)
  }
  
}

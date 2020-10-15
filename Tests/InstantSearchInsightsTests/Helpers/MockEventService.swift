//
//  MockEventService.swift
//  InsightsTests
//
//  Created by Robert Mogos on 12/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
@testable import InstantSearchInsights

class MockEventService: EventsService {
  
  var didSendEvents: ([InsightsEvent]) -> Void
  
  public init(didSendEvents: @escaping ([InsightsEvent]) -> Void) {
    self.didSendEvents = didSendEvents
  }
  
  func sendEvents(_ events: [InsightsEvent], completion: @escaping ResultCallback<Empty>) {
    didSendEvents(events)
    completion(.success(.empty))
  }
  
}

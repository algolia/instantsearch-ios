//
//  MockEventService.swift
//  InsightsTests
//
//  Created by Robert Mogos on 12/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchInsights

class MockEventService<Event>: EventsService {
    
  
  var didSendEvents: ([Event]) -> Void
  
  public init(didSendEvents: @escaping ([Event]) -> Void = { _ in }) {
    self.didSendEvents = didSendEvents
  }
  
  func sendEvents(_ events: [Event], completion: @escaping (Result<Void, Error>) -> Void) {
    didSendEvents(events)
    completion(.success(()))
  }
  
  static func isRetryable(_ error: Error) -> Bool {
    return true
  }

}

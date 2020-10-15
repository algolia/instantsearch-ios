//
//  EventProcessor+AlgoliaClient.swift
//  
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
import AlgoliaSearchClient

extension InsightsClient: EventsService {
  
  public func sendEvents(_ events: [InsightsEvent], completion: @escaping ResultCallback<Empty>) {
    sendEvents(events, requestOptions: nil, completion: completion)
  }
  
}

extension EventProcessor {
  
  public convenience init(applicationID: ApplicationID,
                          apiKey: APIKey,
                          region: Region? = nil,
                          flushDelay: TimeInterval,
                          logger: Logger,
                          dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {
    let client = InsightsClient(appID: applicationID, apiKey: apiKey, region: region)
    self.init(eventsService: client,
              flushDelay: flushDelay,
              logger: logger,
              dispatchQueue: dispatchQueue)
  }
  
}

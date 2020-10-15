//
//  EventsService.swift
//  
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
import AlgoliaSearchClient

public protocol EventsService {
  func sendEvents(_ events: [InsightsEvent], completion: @escaping ResultCallback<Empty>)
}


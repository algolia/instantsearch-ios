//
//  EventProcessor+AlgoliaClient.swift
//  
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
import AlgoliaSearchClient

extension EventProcessor: EventProcessable where Service.Event == InsightsEvent {}

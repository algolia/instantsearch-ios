//
//  InsightsClient+EventService.swift
//
//
//  Created by Vladislav Fitc on 20/10/2020.
//

import Core
import Foundation
import Insights

extension InsightsClient: EventsService {
  public func sendEvents(_ events: [InsightsEvent], completion: @escaping (Result<Void, Error>) -> Void) {
    let items = events.compactMap(\.eventsItem)
    guard !items.isEmpty else {
      completion(.success(()))
      return
    }
    let payload = InsightsEvents(events: items)
    Task {
      do {
        _ = try await pushEvents(insightsEvents: payload)
        completion(.success(()))
      } catch {
        completion(.failure(error))
      }
    }
  }

  public static func isRetryable(_ error: Error) -> Bool {
    if case let AlgoliaError.httpError(httpError) = error {
      return !(400..<500).contains(httpError.statusCode)
    }
    return true
  }
}

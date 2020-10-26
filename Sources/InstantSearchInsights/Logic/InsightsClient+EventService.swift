//
//  InsightsClient+EventService.swift
//  
//
//  Created by Vladislav Fitc on 20/10/2020.
//

import Foundation
import AlgoliaSearchClient

extension InsightsClient: EventsService {

  public func sendEvents(_ events: [InsightsEvent], completion: @escaping (Result<Void, Error>) -> Void) {
    sendEvents(events, requestOptions: nil) { result in
      switch result {
      case .success:
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  public static func isRetryable(_ error: Error) -> Bool {
    guard let httpError = error as? HTTPError else {
      return true
    }
    // If there is no error or the error is from the Analytics, no need to retry.
    // In case of a WebserviceError the package was wronlgy constructed, no need to retry
    return !(400..<500).contains(httpError.statusCode)
  }

}

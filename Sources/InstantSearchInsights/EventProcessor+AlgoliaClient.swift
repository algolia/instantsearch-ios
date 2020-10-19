//
//  EventProcessor+AlgoliaClient.swift
//  
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
import AlgoliaSearchClient
#if os(iOS)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

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

extension EventProcessor where Service == InsightsClient {

  convenience init(applicationID: ApplicationID,
                   apiKey: APIKey,
                   region: Region? = nil,
                   storage: PackageStorage?,
                   flushDelay: TimeInterval,
                   logger: Logger,
                   dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {
    let client = InsightsClient(appID: applicationID, apiKey: apiKey, region: region)

    let notificationName: Notification.Name?

    #if os(iOS)
    notificationName = UIApplication.willResignActiveNotification
    #elseif canImport(AppKit)
    notificationName = NSApplication.willResignActiveNotification
    #else
    notificationName = nil
    #endif

    self.init(service: client,
              storage: storage,
              packageCapacity: Algolia.Insights.maxEventCountInPackage,
              flushNotificationName: notificationName,
              flushDelay: flushDelay,
              logger: logger,
              dispatchQueue: dispatchQueue)
  }

}

extension EventProcessor: EventProcessable where Service.Event == InsightsEvent {}

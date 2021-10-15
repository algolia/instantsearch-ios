//
//  Insights.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
#if os(iOS)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

/// Main class used for interacting with the InstantSearch Insights library.
///
/// Use:
/// In order to send insights, you first need to register an APP ID and API key
///
/// Once registered, you can simply call `Insights.shared` to send your events
///
/// Example:
/// ````
/// Insights.shared?.search.click(userToken: "user101",
///                               indexName: "myAwesomeIndex",
///                               queryID: "6de2f7eaa537fa93d8f8f05b927953b1",
///                               objectID: "54675051",
///                               position: 1)
/// ````

public class Insights {

  /// Specify the desired API endpoint region
  /// By default API endpoint is routed automatically

  public static var region: Region?

  /// Global application user token
  /// Automatically generated while the first app launch and than stored persistently
  /// Used as a default user token if no user token provided for event or application
  /// - Note: This value is ignored if a custom per-app or per-event user token is provided

  public static var userToken: UserToken {

    let key = "com.algolia.InstantSearch.Insights.UserToken"

    if let existingToken = UserDefaults.standard.string(forKey: key) {
      return UserToken(rawValue: existingToken)
    } else {
      let generatedToken = UUID().uuidString
      UserDefaults.standard.set(generatedToken, forKey: key)
      return UserToken(rawValue: generatedToken)
    }

  }

  /// Application-specific user token
  /// Overrides generated global application user token (see above)
  /// - Note: This value is ignored if a custom per-event user token provided

  public var userToken: UserToken? {

    get {
      return (eventTracker as? EventTracker)?.userToken
    }

    set {
      (eventTracker as? EventTracker)?.userToken = newValue
    }

  }

  /// Synchronization delay of tracked events with server. Default value is 30 seconds.

  public static var flushDelay: TimeInterval = Algolia.Insights.flushDelay {
    didSet {
      for (_, insights) in insightsMap {
        var flushableEventProcessor = insights.eventProcessor as? Flushable
        flushableEventProcessor?.flushDelay = flushDelay
      }
    }
  }

  /// Change this variable to change the default amount of event sent at once.

  public static var minBatchSize: Int = Algolia.Insights.minBatchSize {
    didSet {
      for (_, insights) in insightsMap {
        (insights.eventProcessor as? PackageManageable)?.setPackageCapacity(minBatchSize)
      }
    }
  }

  private static var insightsMap: [ApplicationID: Insights] = [:]
  private static var logger = PrefixedLogger(prefix: nil)

  /// Defines if event tracking is active. Default value is `true`.
  /// In case of set to false, all the events for current application will be ignored.

  public var isActive: Bool {

    get {
      return eventProcessor.isActive
    }

    set {
      eventProcessor.isActive = newValue
    }

  }

  /// Defines if console debug logging enabled. Default value is `false`.

  public var isLoggingEnabled: Bool = false {
    didSet {
      Logger.InstantSearchInsights.isEnabled = isLoggingEnabled
    }
  }

  let eventTracker: EventTrackable
  let eventProcessor: EventProcessable
  let logger: PrefixedLogger

  /// Access an already registered `Insights` without having to pass the `apiKey` and `appId`.
  /// If none or more than one application has been registered, the nil value will be returned.

  public static var shared: Insights? {

    switch insightsMap.count {
    case 0:
      logger.debug("none registered application found. Please use `register(appId:, apiKey:)` method to register your application.")
      return nil

    case 1:
      return insightsMap.first?.value

    default:
      logger.debug("multiple applications registered. Please use `shared(appId:)` function to specify the applicaton.")
      return nil
    }

  }

  /// Access an already registered `Insights` via its `appId`.
  /// If the application was not registered before, the nil value will be returned.
  /// - parameter  appId: The appId of application that is being tracked

  public static func shared(appId: ApplicationID) -> Insights? {
    guard let insightsInstance = insightsMap[appId] else {
      logger.debug("application for this app ID (\(appId)) is not registered. Please use `register(appId:, apiKey:)` method to register your application.")
      return nil
    }

    return insightsInstance
  }

  /// Register your index with a given appId and apiKey
  ///
  /// - parameter  appId: The given app id for which you want to track the events
  /// - parameter  apiKey: The API Key for your `appId`
  /// - parameter  userToken: User token used by default for all the application events, if custom user token is not provided while calling event capturing function
  ///   Default value: .none
  /// - parameter  generateTimestamps: Defines if the events timestamps will be automatically attributed if not provided while calling event capturing function.
  ///   If set to false, the events will be sent without timestamp value and will be automatically attributed on the server that may affect the events accuracy
  ///   Defafult value: true
  /// - parameter  region: The desired API endpoint region
  @discardableResult public static func register(appId: ApplicationID,
                                                 apiKey: APIKey,
                                                 userToken: UserToken? = .none,
                                                 generateTimestamps: Bool = true,
                                                 region: Region? = region) -> Insights {
    let logger = PrefixedLogger(prefix: "application \(appId.rawValue) - ")
    logger.info("application registered")
    let insights = Insights(applicationID: appId,
                            apiKey: apiKey,
                            region: region,
                            flushDelay: Algolia.Insights.flushDelay,
                            userToken: userToken,
                            generateTimestamps: generateTimestamps,
                            logger: logger)
    Insights.insightsMap[appId] = insights
    return insights
  }

  init(eventProcessor: EventProcessable,
       eventTracker: EventTrackable,
       logger: PrefixedLogger) {
    self.eventProcessor = eventProcessor
    self.eventTracker = eventTracker
    self.logger = logger
  }

  convenience init(applicationID: ApplicationID,
                   apiKey: APIKey,
                   region: Region? = region,
                   flushDelay: TimeInterval,
                   userToken: UserToken?,
                   generateTimestamps: Bool,
                   logger: PrefixedLogger) {

    typealias PackageStorage = JSONFilePackageStorage<[Package<InsightsEvent>]>

    let storage: PackageStorage?

    do {
      storage = try PackageStorage(filename: "\(applicationID.rawValue).storage.events")
    } catch let error {
      storage = nil
      logger.error(error)
    }

    let insightsClient = InsightsClient(appID: applicationID, apiKey: apiKey, region: region)

    let acceptEvent: (InsightsEvent) -> Bool = { event in
      guard let timestamp = event.timestamp else {
        return true
      }
      let timestampDelta = Date().timeIntervalSince1970.milliseconds - timestamp
      return timestampDelta < Algolia.Insights.eventExpirationDelay
    }

    let notificationName: Notification.Name?

    #if os(iOS)
    notificationName = UIApplication.willResignActiveNotification
    #elseif canImport(AppKit)
    notificationName = NSApplication.willResignActiveNotification
    #else
    notificationName = nil
    #endif

    let queue: DispatchQueue = .init(label: "insights.events", qos: .background)

    let eventsProcessor = EventProcessor(service: insightsClient,
                                         storage: storage,
                                         packageCapacity: Algolia.Insights.minBatchSize,
                                         flushNotificationName: notificationName,
                                         flushDelay: flushDelay,
                                         acceptEvent: acceptEvent,
                                         logger: logger,
                                         dispatchQueue: queue)

    let eventTracker = EventTracker(eventProcessor: eventsProcessor,
                                    logger: logger,
                                    userToken: userToken,
                                    generateTimestamps: generateTimestamps)
    self.init(eventProcessor: eventsProcessor,
              eventTracker: eventTracker,
              logger: logger)
  }

}

//
//  Insights.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

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

@objcMembers public class Insights: NSObject {
    
    /// Specify the desired API endpoint region
    /// By default API endpoint is routed automatically

    public static var region: Region?
    
    /// Global application user token
    /// Automatically generated while the first app launch and than stored persistently
    /// Used as a default user token if no user token provided for event or application
    /// - Note: This value is ignored if a custom per-app or per-event user token is provided
    
    public static var userToken: String {
        
        let key = "com.algolia.InstantSearch.Insights.UserToken"
        
        if let existingToken = UserDefaults.standard.string(forKey: key) {
            return existingToken
        } else {
            let generatedToken = UUID().uuidString
            UserDefaults.standard.set(generatedToken, forKey: key)
            return generatedToken
        }
        
    }
    
    /// Application-specific user token
    /// Overrides generated global application user token (see above)
    /// - Note: This value is ignored if a custom per-event user token provided
    
    public var userToken: String? {
        
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
    
    private static var insightsMap: [String: Insights] = [:]
    private static var logger = Logger("Main")
    
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
            logger.enabled = isLoggingEnabled
        }
    }
    
    let eventTracker: EventTrackable
    let eventProcessor: EventProcessable
    let logger: Logger
    
    /// Access an already registered `Insights` without having to pass the `apiKey` and `appId`.
    /// If none or more than one application has been registered, the nil value will be returned.
    
    public static var shared: Insights? {
        
        switch insightsMap.count {
        case 0:
            logger.debug(message: "None registered application found. Please use `register(appId: String, apiKey: String)` method to register your application.")
            return nil
            
        case 1:
            return insightsMap.first?.value
            
        default:
            logger.debug(message: "Multiple applications registered. Please use `shared(appId: String)` function to specify the applicaton.")
            return nil
        }
        
    }
    
    /// Access an already registered `Insights` via its `appId`.
    /// If the application was not registered before, the nil value will be returned.
    /// - parameter  appId: The appId of application that is being tracked

    public static func shared(appId: String) -> Insights? {
        guard let insightsInstance = insightsMap[appId] else {
            logger.debug(message: "Application for this app ID (\(appId)) is not registered. Please use `register(appId: String, apiKey: String)` method to register your application.")
            return nil
        }
        
        return insightsInstance
    }
    
    /// Register your index with a given appId and apiKey
    ///
    /// - parameter  appId: The given app id for which you want to track the events
    /// - parameter  apiKey: The API Key for your `appId`
    /// - parameter  userToken: User token used by default for all the application events, if custom user token is not provided while calling event capturing function
    
    @discardableResult public static func register(appId: String,
                                                   apiKey: String,
                                                   userToken: String? = .none) -> Insights {
        let credentials = Credentials(appId: appId, apiKey: apiKey)
        let logger = Logger(appId) { debugMessage in
            DispatchQueue.main.async { print(debugMessage) }
        }
        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let webservice = WebService(sessionConfig: sessionConfig,
                                    logger: logger)
        let insights = Insights(credentials: credentials,
                                webService: webservice,
                                flushDelay: Algolia.Insights.flushDelay,
                                userToken: userToken,
                                logger: logger)
        Insights.insightsMap[appId] = insights
        return insights
    }
    
    init(eventProcessor: EventProcessable,
         eventTracker: EventTrackable,
         logger: Logger) {
        self.eventProcessor = eventProcessor
        self.eventTracker = eventTracker
        self.logger = logger
    }
    
    convenience init(eventsProcessor: EventProcessable,
                     userToken: String? = .none,
                     logger: Logger) {
        let eventTracker = EventTracker(eventProcessor: eventsProcessor,
                                        logger: logger,
                                        userToken: userToken)
        self.init(eventProcessor: eventsProcessor,
                  eventTracker: eventTracker,
                  logger: logger)
    }
    
    convenience init(credentials: Credentials,
                     webService: WebService,
                     flushDelay: TimeInterval,
                     region: Region? = .none,
                     userToken: String? = .none,
                     logger: Logger) {
        let eventsProcessor = EventProcessor(
            credentials: credentials,
            webService: webService,
            region: region,
            flushDelay: flushDelay,
            logger: logger)
        self.init(eventsProcessor: eventsProcessor,
                  userToken: userToken,
                  logger: logger)
    }
    
}

// MARK: - Tracking events tighten to search

extension Insights {
    
    /// Track a click related to search
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter positions: Position of the click in the list of Algolia search results. Positions count must be the same as objectID count.
    /// - parameter queryID: Algolia queryID
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func clickedAfterSearch(eventName: String,
                                   indexName: String,
                                   objectIDs: [String],
                                   positions: [Int],
                                   queryID: String,
                                   userToken: String? = .none) {
        eventTracker.click(eventName: eventName,
                           indexName: indexName,
                           userToken: userToken,
                           objectIDs: objectIDs,
                           positions: positions,
                           queryID: queryID)
    }
    
    /// Track a click related to search
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDsWithPositions: An array of related index objectID and position of the click in the list of Algolia search results. - Warning: Limited to 20 objects.
    /// - parameter queryID: Algolia queryID
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func clickedAfterSearch(eventName: String,
                                   indexName: String,
                                   objectIDsWithPositions: [(String, Int)],
                                   queryID: String,
                                   userToken: String? = .none) {
        clickedAfterSearch(eventName: eventName,
                           indexName: indexName,
                           objectIDs: objectIDsWithPositions.map { $0.0 },
                           positions: objectIDsWithPositions.map { $0.1 },
                           queryID: queryID,
                           userToken: userToken)
    }
    
    /// Track a click related to search
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectID: Index objectID
    /// - parameter position: Position of the click in the list of Algolia search results
    /// - parameter queryID: Algolia queryID
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func clickedAfterSearch(eventName: String,
                                   indexName: String,
                                   objectID: String,
                                   position: Int,
                                   queryID: String,
                                   userToken: String? = .none) {
        clickedAfterSearch(eventName: eventName,
                           indexName: indexName,
                           objectIDs: [objectID],
                           positions: [position],
                           queryID: queryID,
                           userToken: userToken)
    }
    
    /// Track a conversion related to search
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter queryID: Algolia queryID
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func convertedAfterSearch(eventName: String,
                                     indexName: String,
                                     objectIDs: [String],
                                     queryID: String,
                                     userToken: String? = .none) {
        eventTracker.conversion(eventName: eventName,
                                indexName: indexName,
                                userToken: userToken,
                                objectIDs: objectIDs,
                                queryID: queryID)
    }
    
    /// Track a conversion related to search
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectID: Index objectID
    /// - parameter queryID: Algolia queryID
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func convertedAfterSearch(eventName: String,
                                     indexName: String,
                                     objectID: String,
                                     queryID: String,
                                     userToken: String? = .none) {
        eventTracker.conversion(eventName: eventName,
                                indexName: indexName,
                                userToken: userToken,
                                objectIDs: [objectID],
                                queryID: queryID)
    }
    
}

// MARK: - Tracking events non-tighten to search

extension Insights {
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func viewed(eventName: String,
                       indexName: String,
                       objectIDs: [String],
                       userToken: String? = .none) {
        eventTracker.view(eventName: eventName,
                          indexName: indexName,
                          userToken: userToken,
                          objectIDs: objectIDs)
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectID: Index objectID.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func viewed(eventName: String,
                       indexName: String,
                       objectID: String,
                       userToken: String? = .none) {
        eventTracker.view(eventName: eventName,
                          indexName: indexName,
                          userToken: userToken,
                          objectIDs: [objectID])
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter filters: An array of filters. Limited to 10 filters.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func viewed(eventName: String,
                       indexName: String,
                       filters: [String],
                       userToken: String? = .none) {
        eventTracker.view(eventName: eventName,
                          indexName: indexName,
                          userToken: userToken,
                          filters: filters)
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func clicked(eventName: String,
                        indexName: String,
                        objectIDs: [String],
                        userToken: String? = .none) {
        eventTracker.click(eventName: eventName,
                           indexName: indexName,
                           userToken: userToken,
                           objectIDs: objectIDs)
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectID: Index objectID.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func clicked(eventName: String,
                        indexName: String,
                        objectID: String,
                        userToken: String? = .none) {
        eventTracker.click(eventName: eventName,
                           indexName: indexName,
                           userToken: userToken,
                           objectIDs: [objectID])
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter filters: An array of filters. Limited to 10 filters.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func clicked(eventName: String,
                        indexName: String,
                        filters: [String],
                        userToken: String? = .none) {
        eventTracker.click(eventName: eventName,
                           indexName: indexName,
                           userToken: userToken,
                           filters: filters)
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func converted(eventName: String,
                          indexName: String,
                          objectIDs: [String],
                          userToken: String? = .none) {
        eventTracker.conversion(eventName: eventName,
                                indexName: indexName,
                                userToken: userToken,
                                objectIDs: objectIDs)
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectID: Index objectID.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func converted(eventName: String,
                          indexName: String,
                          objectID: String,
                          userToken: String? = .none) {
        eventTracker.conversion(eventName: eventName,
                                indexName: indexName,
                                userToken: userToken,
                                objectIDs: [objectID])
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter filters: An array of filters. Limited to 10 filters.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    
    public func converted(eventName: String,
                          indexName: String,
                          filters: [String],
                          userToken: String? = .none) {
        eventTracker.conversion(eventName: eventName,
                                indexName: indexName,
                                userToken: userToken,
                                filters: filters)
    }
    
}

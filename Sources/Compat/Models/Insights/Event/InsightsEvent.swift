//
//  InsightsEvent.swift
//
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

public struct InsightsEvent {

  public let type: EventType
  public let name: EventName
  public let indexName: IndexName
  public let userToken: UserToken?
  public let timestamp: Int64?
  public let queryID: QueryID?
  public let resources: Resources

  init(type: EventType,
       name: EventName,
       indexName: IndexName,
       userToken: UserToken?,
       timestamp: Int64?,
       queryID: QueryID?,
       resources: Resources) throws {

    try ConstructionError.checkEventName(name)
    try ConstructionError.check(resources)

    self.type = type
    self.name = name
    self.indexName = indexName
    self.userToken = userToken
    self.timestamp = timestamp
    self.queryID = queryID
    self.resources = resources
  }

  init(type: EventType,
       name: EventName,
       indexName: IndexName,
       userToken: UserToken?,
       timestamp: Date?,
       queryID: QueryID?,
       resources: Resources) throws {
    let rawTimestamp = timestamp?.timeIntervalSince1970.milliseconds
    try self.init(type: type,
                  name: name,
                  indexName: indexName,
                  userToken: userToken,
                  timestamp: rawTimestamp,
                  queryID: queryID,
                  resources: resources)
  }

}

extension InsightsEvent: Codable {

  enum CodingKeys: String, CodingKey, CaseIterable {
    case type = "eventType"
    case name = "eventName"
    case indexName = "index"
    case userToken
    case timestamp
    case queryID
    case positions
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.type = try container.decode(forKey: .type)
    self.name = try container.decode(forKey: .name)
    self.indexName = try container.decode(forKey: .indexName)
    self.userToken = try container.decodeIfPresent(forKey: .userToken)
    self.timestamp = try container.decodeIfPresent(forKey: .timestamp)
    self.queryID = try container.decodeIfPresent(forKey: .queryID)
    self.resources = try Resources(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(type, forKey: .type)
    try container.encode(name, forKey: .name)
    try container.encode(indexName, forKey: .indexName)
    try container.encodeIfPresent(userToken, forKey: .userToken)
    try container.encodeIfPresent(timestamp, forKey: .timestamp)
    try container.encodeIfPresent(queryID, forKey: .queryID)
    try resources.encode(to: encoder)
  }

}

extension InsightsEvent: CustomStringConvertible {

  public var description: String {
    """
    \n{
      name: \"\(name)\",
      type: \(type),
      indexName: \(indexName),
      userToken: \(userToken ?? "none"),
      timestamp: \(timestamp?.description ?? "none"),
      queryID: \(queryID ?? "none"),
      \(resources)
    }
    """
  }

}

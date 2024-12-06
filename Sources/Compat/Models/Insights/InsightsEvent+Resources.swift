//
//  InsightsEvent+Resources.swift
//  
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

extension InsightsEvent {

  public enum Resources: Equatable {
    case objectIDs([ObjectID])
    case filters([String])
    case objectIDsWithPositions([(ObjectID, Int)])

    public static func == (lhs: InsightsEvent.Resources, rhs: InsightsEvent.Resources) -> Bool {
      switch (lhs, rhs) {
      case (.objectIDs(let lValue), .objectIDs(let rValue)):
        return lValue == rValue
      case (.filters(let lValue), .filters(let rValue)):
        return lValue == rValue
      case (.objectIDsWithPositions(let lValue), .objectIDsWithPositions(let rValue)):
        return lValue.map { $0.0 } == rValue.map { $0.0 } && lValue.map { $0.1 } == rValue.map { $0.1 }
      default:
        return false
      }
    }

  }

}

extension InsightsEvent.Resources: CustomStringConvertible {

  public var description: String {
    switch self {
    case .filters(let filters):
      return "filters: \(filters)"
    case .objectIDs(let objectIDs):
      return "object IDs: \(objectIDs)"
    case .objectIDsWithPositions(let objectIDsPositions):
      return "object IDs & positions: \(objectIDsPositions)"
    }
  }

}

extension InsightsEvent.Resources: Codable {

  enum CodingKeys: String, CodingKey {
    case objectIDs
    case filters
    case positions
  }

  public init(from decoder: Decoder) throws {

    let container = try decoder.container(keyedBy: CodingKeys.self)

    let objectIDsDecodingError: Error
    let filtersDecodingError: Error

    do {
      let objectIDs = try container.decode([ObjectID].self, forKey: .objectIDs)
      if let positions = try? container.decode([Int].self, forKey: .positions) {
        self = .objectIDsWithPositions(zip(objectIDs, positions).map { $0 })
      } else {
        self = .objectIDs(objectIDs)
      }
      return
    } catch let error {
      objectIDsDecodingError = error
    }

    do {
      let filters = try container.decode([String].self, forKey: .filters)
      self = .filters(filters)
      return
    } catch let error {
      filtersDecodingError = error
    }

    let compositeError = CompositeError.with(objectIDsDecodingError, filtersDecodingError)
    typealias Keys = InsightsEvent.Resources.CodingKeys
    let context = DecodingError.Context(codingPath: decoder.codingPath,
                                        debugDescription: "Neither \(Keys.filters.rawValue), nor \(Keys.objectIDs.rawValue) key found on decoder",
                                        underlyingError: compositeError)
    throw DecodingError.dataCorrupted(context)
  }

  public func encode(to encoder: Encoder) throws {

    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .filters(let filters):
      try container.encode(filters, forKey: .filters)

    case .objectIDsWithPositions(let objectIDswithPositions):
      try container.encode(objectIDswithPositions.map { $0.0 }, forKey: .objectIDs)
      try container.encode(objectIDswithPositions.map { $0.1 }, forKey: .positions)

    case .objectIDs(let objectsIDs):
      try container.encode(objectsIDs, forKey: .objectIDs)
    }

  }

}

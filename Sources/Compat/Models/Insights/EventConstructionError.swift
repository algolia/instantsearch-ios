//
//  EventConstructionError.swift
//  
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

public extension InsightsEvent {

  enum Constraints {
    public static let maxObjectIDsCount = 20
    public static let maxFiltersCount = 10
  }

  enum ConstructionError: Error {

    case emptyEventName
    case objectIDsCountOverflow
    case filtersCountOverflow
    case objectsAndPositionsCountMismatch(objectIDsCount: Int, positionsCount: Int)

    static func checkEventName(_ eventName: EventName) throws {
      if eventName.rawValue.isEmpty {
        throw ConstructionError.emptyEventName
      }
    }

    static func check(_ resources: InsightsEvent.Resources) throws {
      switch resources {
      case .filters(let filters) where filters.count > Constraints.maxFiltersCount:
        throw ConstructionError.filtersCountOverflow

      case .objectIDs(let objectIDs) where objectIDs.count > Constraints.maxObjectIDsCount:
        throw ConstructionError.objectIDsCountOverflow

      default:
        break
      }
    }

  }

}

extension InsightsEvent.ConstructionError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .emptyEventName:
      return "Event name cannot be empty"

    case .filtersCountOverflow:
      return "Max filters count in event is \(InsightsEvent.Constraints.maxFiltersCount)"

    case .objectIDsCountOverflow:
      return "Max objects IDs count in event is \(InsightsEvent.Constraints.maxObjectIDsCount)"

    case .objectsAndPositionsCountMismatch(objectIDsCount: let objectIDsCount, positionsCount: let positionsCount):
      return "Object IDs count \(objectIDsCount) is not equal to positions count \(positionsCount)"
    }
  }

}

//
//  CallType.swift
//  
//
//  Created by Vladislav Fitc on 02/06/2020.
//

import Foundation

/**
 * Indicate whether the HTTP call performed is of type [read] (GET) or [write] (POST, PUT ..).
 * Used to determine which timeout duration to use.
 */
public enum CallType {
    case read, write
}

extension CallType: CustomStringConvertible {
  public var description: String {
    switch self {
    case .read:
      return "read"
    case .write:
      return "write"
    }
  }
}

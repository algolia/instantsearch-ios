//
//  LogType.swift
//
//
//  Created by Vladislav Fitc on 07/04/2020.
//

import Foundation

// FIXME: Should Search.LogType be used instead?
public struct LogType: Codable {

  let rawValue: String

  /// Retrieve all the logs.
  public static var all: Self { .init(rawValue: #function) }

  /// Retrieve only the queries.
  public static var query: Self { .init(rawValue: #function) }

  /// Retrieve only the build operations.
  public static var build: Self { .init(rawValue: #function) }

  /// Retrieve only the errors.
  public static var error: Self { .init(rawValue: #function) }

  public static func other(_ rawValue: String) -> Self { .init(rawValue: rawValue) }

}

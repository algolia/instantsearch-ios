//
//  TaskStatus.swift
//
//
//  Created by Vladislav Fitc on 06.03.2020.
//

import Foundation

// FIXME: Should Search.SearchTaskStatus be used instead?
public struct TaskStatus: StringOption, ProvidingCustomOption {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// The Task has been processed by the server.
  public static var published: Self { .init(rawValue: #function) }

  /// The Task has not yet been processed by the server.
  public static var notPublished: Self { .init(rawValue: #function) }

}

//
//  TaskInfo.swift
//  
//
//  Created by Vladislav Fitc on 06.03.2020.
//

import Foundation

public struct TaskInfo: Codable {

  /// The Task current TaskStatus.
  public let status: TaskStatus

  /// Whether the index has remaining Task is running
  public let pendingTask: Bool

}

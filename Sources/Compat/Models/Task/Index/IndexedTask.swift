//
//  IndexedTask.swift
//  
//
//  Created by Vladislav Fitc on 15/04/2020.
//

import Foundation

public struct IndexedTask: IndexTask {

  /// The name of the index this task is running on.
  public let indexName: IndexName

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

}

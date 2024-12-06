//
//  TaskWaitable.swift
//  
//
//  Created by Vladislav Fitc on 25/01/2021.
//

import Foundation

protocol TaskWaitable {

  func waitTask(withID taskID: TaskID, timeout: TimeInterval?, requestOptions: RequestOptions?, completion: @escaping ResultCallback<TaskStatus>) -> Operation
  func waitTask(withID taskID: TaskID, timeout: TimeInterval?, requestOptions: RequestOptions?) throws -> TaskStatus

}

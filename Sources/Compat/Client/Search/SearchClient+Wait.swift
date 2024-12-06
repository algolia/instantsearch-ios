//
//  SearchClient+Wait.swift
//  
//
//  Created by Vladislav Fitc on 22/01/2021.
//

import Foundation

public extension Client {

  // MARK: - Task status

  /**
    Check the current TaskStatus of a given Task.
   
    - parameter taskID: of the indexing [Task].
    - parameter requestOptions: Configure request locally with [RequestOptions]
  */
  @discardableResult func taskStatus(for taskID: AppTaskID,
                                     requestOptions: RequestOptions? = nil,
                                     completion: @escaping  ResultCallback<TaskInfo>) -> Operation & TransportTask {
    let command = Command.Advanced.AppTaskStatus(taskID: taskID, requestOptions: requestOptions)
    return execute(command, completion: completion)
  }

  /**
    Check the current TaskStatus of a given Task.
   
    - parameter taskID: of the indexing [Task].
    - parameter requestOptions: Configure request locally with [RequestOptions]
  */
  @discardableResult func taskStatus(for taskID: AppTaskID,
                                     requestOptions: RequestOptions? = nil) throws -> TaskInfo {
    let command = Command.Advanced.AppTaskStatus(taskID: taskID, requestOptions: requestOptions)
    return try execute(command)
  }

  // MARK: - Wait task

  /**
    Wait for a Task to complete before executing the next line of code, to synchronize index updates.
    All write operations in Algolia are asynchronous by design.
    It means that when you add or update an object to your index, our servers will reply to your request with
    a TaskID as soon as they understood the write operation.
    The actual insert and indexing will be done after replying to your code.
    You can wait for a task to complete by using the TaskID and this method.
   
    - parameter taskID: of the indexing task to wait for.
    - parameter requestOptions: Configure request locally with RequestOptions
  */
  @discardableResult func waitTask(withID taskID: AppTaskID,
                                   timeout: TimeInterval? = nil,
                                   requestOptions: RequestOptions? = nil,
                                   completion: @escaping ResultCallback<TaskStatus>) -> Operation {
    let task = WaitTask(client: self,
                        taskID: taskID,
                        timeout: timeout,
                        requestOptions: requestOptions,
                        completion: completion)
    return launch(task)
  }

  /**
    Wait for a Task to complete before executing the next line of code, to synchronize index updates.
    All write operations in Algolia are asynchronous by design.
    It means that when you add or update an object to your index, our servers will reply to your request with
    a TaskID as soon as they understood the write operation.
    The actual insert and indexing will be done after replying to your code.
    You can wait for a task to complete by using the TaskID and this method.
   
    - parameter taskID: of the indexing task to wait for.
    - parameter requestOptions: Configure request locally with RequestOptions
  */
  @discardableResult func waitTask(withID taskID: AppTaskID,
                                   timeout: TimeInterval? = nil,
                                   requestOptions: RequestOptions? = nil) throws -> TaskStatus {
    let task = WaitTask(client: self,
                        taskID: taskID,
                        timeout: timeout,
                        requestOptions: requestOptions,
                        completion: { _ in })
    return try launch(task)
  }

}

//
//  Waitable.swift
//
//
//  Created by Vladislav Fitc on 01/02/2021.
//

import Foundation
import Search

// FIXME: Removed in v9
typealias Client = SearchClient

struct Waitable: AnyWaitable {

  let asyncCall: (TimeInterval?, RequestOptions?, @escaping ResultCallback<Empty>) -> Void
  let syncCall: (TimeInterval?, RequestOptions?) throws -> Void

  init(index: Index, taskID: TaskID) {
    asyncCall = { timeout, requestOptions, completion in index.waitTask(withID: taskID, timeout: timeout, requestOptions: requestOptions, completion: { result in completion(result.map { _ in .empty }) }) }
    syncCall = { try index.waitTask(withID: taskID, timeout: $0, requestOptions: $1) }
  }

  init(client: Client, task: IndexedTask) {
    // FIXME: Client v9 removes index method
    self.init(index: client.index(withName: task.indexName), taskID: task.taskID)
  }

  init(client: SearchClient, taskID: AppTaskID) {
    asyncCall = { timeout, requestOptions, completion in client.waitTask(withID: taskID, timeout: timeout, requestOptions: requestOptions, completion: { result in completion(result.map { _ in .empty }) }) }
    syncCall = { try client.waitTask(withID: taskID, timeout: $0, requestOptions: $1) }
  }

  public func wait(timeout: TimeInterval? = nil,
                   requestOptions: RequestOptions? = nil) throws {
    try syncCall(timeout, requestOptions)
  }

  public func wait(timeout: TimeInterval? = nil,
                   requestOptions: RequestOptions? = nil,
                   completion: @escaping (Result<Empty, Swift.Error>) -> Void) {
    asyncCall(timeout, requestOptions, completion)
  }

}

//
//  TaskWaitWrapper.swift
//
//
//  Created by Vladislav Fitc on 16/04/2020.
//

import Foundation

public struct WaitableWrapper<T> {

  public let wrapped: T
  let tasksToWait: [Waitable]

}

extension WaitableWrapper where T: IndexTask {

  public var task: T {
    return wrapped
  }

  init(task: T, index: Index) {
    self.wrapped = task
    self.tasksToWait = [.init(index: index, taskID: task.taskID)]
  }

  static func wrap(with index: Index) -> (T) -> WaitableWrapper<T> {
    return { task in
      return WaitableWrapper(task: task, index: index)
    }
  }

}

extension WaitableWrapper where T == [IndexTask] {

  public var tasks: T {
    return wrapped
  }

  init(tasks: [IndexTask], index: Index) {
    self.wrapped = tasks
    self.tasksToWait = tasks.map { Waitable(index: index, taskID: $0.taskID) }
  }

}

extension WaitableWrapper where T: AppTask {

  public var task: T {
    return wrapped
  }

  init(task: T, client: SearchClient) {
    self.wrapped = task
    self.tasksToWait = [.init(client: client, taskID: task.taskID)]
  }

  static func wrap(with client: SearchClient) -> (T) -> WaitableWrapper<T> {
    return { task in
      return WaitableWrapper(task: task, client: client)
    }
  }

}

extension WaitableWrapper where T: IndexTask & IndexNameContainer {

  static func wrap(credentials: Credentials) -> (T) -> WaitableWrapper<T> {
    return { task in
      let index = SearchClient(appID: credentials.applicationID, apiKey: credentials.apiKey).index(withName: task.indexName)
      return WaitableWrapper(task: task, index: index)
    }
  }

}

extension WaitableWrapper where T == BatchesResponse {

  public var batchesResponse: BatchesResponse {
    return wrapped
  }

  init(batchesResponse: T, client: SearchClient) {
    self.wrapped = batchesResponse
    self.tasksToWait = batchesResponse.tasks.map { Waitable(index: client.index(withName: $0.indexName), taskID: $0.taskID) }
  }

  init(batchesResponse: T, index: Index) {
    self.wrapped = batchesResponse
    self.tasksToWait = batchesResponse.tasks.map { Waitable(index: index, taskID: $0.taskID) }
  }

}

extension WaitableWrapper: AnyWaitable {

  public func wait(timeout: TimeInterval? = nil,
                   requestOptions: RequestOptions? = nil) throws {
    for waiter in tasksToWait {
      try waiter.wait(timeout: timeout, requestOptions: requestOptions)
    }
  }

  public func wait(timeout: TimeInterval? = nil,
                   requestOptions: RequestOptions? = nil,
                   completion: @escaping (Result<Empty, Swift.Error>) -> Void) {
    let dispatchGroup = DispatchGroup()
    var outputError: Error?
    for waiter in tasksToWait {
      dispatchGroup.enter()
      waiter.wait(timeout: timeout,
                  requestOptions: requestOptions) { result in
        switch result {
        case .success:
          break
        case .failure(let error):
          outputError = error
        }
        dispatchGroup.leave()
      }
    }
    dispatchGroup.notify(queue: .global(qos: .userInteractive)) {
      completion(outputError.flatMap { .failure($0) } ?? .success(.empty))
    }
  }

}

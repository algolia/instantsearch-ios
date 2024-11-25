//
//  OperationLauncher.swift
//  
//
//  Created by Vladislav Fitc on 03/04/2020.
//

import Foundation

class OperationLauncher {

  let queue: OperationQueue

  init(queue: OperationQueue) {
    self.queue = queue
#if os(Linux)
    self.queue.underlyingQueue = DispatchQueue
      .global(qos: DispatchQoS.QoSClass.background)
#endif
  }

  @discardableResult func launch<O: Operation>(_ operation: O) -> O {
    queue.addOperation(operation)
    return operation
  }

  func launchSync<O: OperationWithResult>(_ operation: O) throws -> O.ResultValue {
    queue.addOperation(operation)
    operation.waitUntilFinished()
    guard !operation.isCancelled else {
      throw SyncOperationError.cancelled
    }
    return try operation.result.get()
  }
}

public typealias OperationWithResult = Operation & ResultContainer

public enum SyncOperationError: LocalizedError {
  case cancelled
  case notFinished

  public var errorDescription: String? {
    switch self {
    case .cancelled:
      return "Attempt to launch the cancelled operation"
    case .notFinished:
      return "Operation is in progress"
    }
  }

}

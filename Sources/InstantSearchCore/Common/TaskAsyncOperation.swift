//
//  TaskAsyncOperation.swift
//  InstantSearchCore
//

import Foundation

final class TaskAsyncOperation: AsyncOperation {
  private let work: () async -> Void
  private var task: Task<Void, Never>?

  init(work: @escaping () async -> Void) {
    self.work = work
    super.init()
  }

  override func main() {
    task = Task { [weak self] in
      await work()
      self?.state = .finished
    }
  }

  override func cancel() {
    task?.cancel()
    super.cancel()
  }
}


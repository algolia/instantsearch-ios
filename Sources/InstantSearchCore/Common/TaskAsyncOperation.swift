//
//  TaskAsyncOperation.swift
//  InstantSearchCore
//

import Foundation

final class TaskAsyncOperation: AsyncOperation, @unchecked Sendable {
  private let work: () async -> Void
  private var task: Task<Void, Never>?

  init(work: @escaping () async -> Void) {
    self.work = work
    super.init()
  }

  override func main() {
    let work = work
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

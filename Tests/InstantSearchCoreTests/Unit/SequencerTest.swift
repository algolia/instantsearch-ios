//
//  Copyright (c) 2017 Algolia
//  http://www.algolia.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@testable import InstantSearchCore
import XCTest

class AsyncOperation: Operation {

  public enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      return "is" + rawValue.capitalized
    }
  }

  public var state: State = .ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }

  override var isAsynchronous: Bool {
    return true
  }

  override var isReady: Bool {
    return super.isReady && state == .ready
  }

  override var isExecuting: Bool {
    return state == .executing
  }

  override var isFinished: Bool {
    return state == .finished
  }

  override func start() {
    if isCancelled {
      state = .finished
      return
    }

    main()
    state = .executing
  }

  override func cancel() {
    super.cancel()
    state = .finished
  }

}

class DelayedOperation: AsyncOperation {

  let delay: Int
  let completionHandler: (() -> Void)?

  init(delay: Int = 20, completionHandler: (() -> Void)? = .none) {
    self.delay = delay
    self.completionHandler = completionHandler
    super.init()
  }

  override var debugDescription: String {
    return "\(name ?? "")"
  }

  override func main() {
    let deadline = DispatchTime.now() + .milliseconds(delay)
    DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
      guard let operation = self else { return }
      defer {
        operation.state = .finished
      }
      if operation.isCancelled {
        return
      }
      operation.completionHandler?()
    }

  }

  override func cancel() {
    super.cancel()
  }

}

class SequencerTest: XCTestCase {

  func testObsoleteOperationsCancellation() {

    let sequencer = Sequencer()
    sequencer.maxPendingOperationsCount = 10

    let operationsCount = 100
    let exp = expectation(description: "delayed operation")
    exp.expectedFulfillmentCount = sequencer.maxPendingOperationsCount
    exp.assertForOverFulfill = false

    let operations: [Operation] = (0..<operationsCount).map { number in
      let op = DelayedOperation(delay: 10, completionHandler: { exp.fulfill() })
      op.name = "\(number+1)"
      return op
    }

    let testQueue = OperationQueue()
    testQueue.maxConcurrentOperationCount = 10

    // Launch 100 delayed operations that last 10 seconds each and add them to sequencer with max 10 pending operations
    operations.forEach { operation in
      testQueue.addOperation(operation)
      sequencer.orderOperation { operation }
    }

    // Check the state of operations in 5 seconds
    waitForExpectations(timeout: 5, handler: .none)

    // Sequencer must cancel first 90 ordered operations
    XCTAssertEqual(operations.filter { $0.isCancelled }.count, operationsCount - sequencer.maxPendingOperationsCount)
    
    // Last 10 operations still in progress as they last longer than 5 seconds
    XCTAssertEqual(operations.filter { !$0.isCancelled }.count, sequencer.maxPendingOperationsCount)

  }

  func testPreviousOperationsCancellation() {

    let sequencer = Sequencer()

    let slowOperationsCount = 100

    sequencer.maxPendingOperationsCount = slowOperationsCount + 1

    let slowOperations: [Operation] = (0..<slowOperationsCount).map { number in
      let op = DelayedOperation(delay: .random(in: 100...300), completionHandler: .none)
      op.name = "\(number+1)"
      let exp = expectation(description: "\(number)")
      op.completionBlock = {
        exp.fulfill()
      }
      return op
    }

    let exp = expectation(description: "fast operation")
    let fastOperation = DelayedOperation(delay: 1, completionHandler: exp.fulfill)
    fastOperation.name = "fast"

    let testQueue = OperationQueue()
    testQueue.maxConcurrentOperationCount = 200

    // Launch 100 slow operations and 1 fast operation and add them to the sequencer supporting 101 concurrent operations
    slowOperations.forEach { operation in
      testQueue.addOperation(operation)
      sequencer.orderOperation { operation }
    }
    testQueue.addOperation(fastOperation)
    sequencer.orderOperation { fastOperation }

    // Wait for success of the fast operation
    waitForExpectations(timeout: 100, handler: .none)

    // All slow operations must be cancelled as the seqNo of the fast operation is bigger than the seqNo of the slow operations
    XCTAssertEqual(slowOperations.filter { $0.isCancelled }.count, slowOperationsCount)
    
    // Fast operation shouldn't be cancelled
    XCTAssertFalse(fastOperation.isCancelled)

  }
  
  func testPendingOperations() {

    let sequencer = Sequencer()

    sequencer.maxPendingOperationsCount = 3

    let exp = expectation(description: "op expectation")

    let op1 = DelayedOperation(delay: 1000, completionHandler: exp.fulfill)
    op1.name = "Operation!!!"

    let testQueue = OperationQueue()
    testQueue.addOperation(op1)

    sequencer.orderOperation { op1 }
    XCTAssertTrue(sequencer.hasPendingOperations)

    waitForExpectations(timeout: 5, handler: .none)

  }
  
  func testLoad() {
        
    let sequencer = Sequencer()

    sequencer.maxPendingOperationsCount = 100
    
    let queueCount = 30
    // Generate `queueCount` queues with associated count of operation for each
    let queuesWithOpCount = (1...queueCount)
      .map { (queue: DispatchQueue(label: "queue\($0)"), operationCount: Int.random(in: 100...1000)) }
    
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 50
    
    // Expectation of completion of all the operations from all the queues
    let allOperationsFinishedExpectation = expectation(description: "All operations finished")
    allOperationsFinishedExpectation.expectedFulfillmentCount = queuesWithOpCount.map(\.operationCount).reduce(0, +)
    
    // Launch `operationCount` operation from each queue with randomized launch delay and randomized operation execution delay
    for (queue, operationCount) in queuesWithOpCount {
      for count in 1...operationCount {
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: 10...500))) {
          let operation = DelayedOperation(delay: .random(in: 10...200), completionHandler: .none)
          operation.name = "\(queue.label) - \(count)"
          operation.completionBlock = {
            allOperationsFinishedExpectation.fulfill()
          }
          sequencer.orderOperation {
            operationQueue.addOperation(operation)
            return operation
          }
        }
      }
    }

    waitForExpectations(timeout: 10, handler: nil)
    
  }

  
  
}

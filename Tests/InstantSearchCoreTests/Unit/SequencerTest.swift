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

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testObsoleteOperationsCancellation() {

    let sequencer = Sequencer()
    sequencer.maxPendingOperationsCount = 10

    let operationsCount = 100
    let exp = expectation(description: "delayed operation")
    exp.expectedFulfillmentCount = sequencer.maxPendingOperationsCount

    let operations: [Operation] = (0..<operationsCount).map { number in
      let op = DelayedOperation(delay: 10, completionHandler: { exp.fulfill() })
      op.name = "\(number+1)"
      return op
    }

    let testQueue = OperationQueue()
    testQueue.maxConcurrentOperationCount = 10

    operations.forEach { operation in
      testQueue.addOperation(operation)
      sequencer.orderOperation { operation }
    }

    waitForExpectations(timeout: 5, handler: .none)

    XCTAssertEqual(operations.filter { $0.isCancelled }.count, operationsCount - sequencer.maxPendingOperationsCount)
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

    slowOperations.forEach { operation in
      testQueue.addOperation(operation)
      sequencer.orderOperation { operation }
    }
    testQueue.addOperation(fastOperation)
    sequencer.orderOperation { fastOperation }

    waitForExpectations(timeout: 100, handler: .none)

    XCTAssertEqual(slowOperations.filter { $0.isCancelled }.count, slowOperationsCount)
    XCTAssertFalse(fastOperation.isCancelled)

  }

  func testPendingOperations() {

    let sequencer = Sequencer()

    sequencer.maxPendingOperationsCount = 3

    let exp = expectation(description: "op expectation")

    let op1 = DelayedOperation(delay: 1, completionHandler: exp.fulfill)

    let testQueue = OperationQueue()
    testQueue.addOperation(op1)

    sequencer.orderOperation { op1 }
    XCTAssertTrue(sequencer.hasPendingOperations)

    waitForExpectations(timeout: 5, handler: .none)
    XCTAssertFalse(sequencer.hasPendingOperations)

  }

}

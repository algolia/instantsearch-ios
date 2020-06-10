//
//  Copyright (c) 2016 Algolia
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

import Foundation

/// Manages a sequence of operations.
/// A `Sequencer` keeps track of the order in which operations have been issued, and cancels obsolete requests whenever a
/// response to a more recent operation is received. This ensures that responses are always received in the right order,
/// or discarded.
///

protocol Sequencable {

    typealias OperationLauncher = () -> Operation

    func orderOperation(operationLauncher: OperationLauncher)
    func cancelPendingOperations()
}

protocol SequencerDelegate: class {
  func didChangeOperationsState(hasPendingOperations: Bool)
}

class Sequencer: Sequencable {

  // MARK: Properties

  /// Sequence number for the next operation.
  private var nextSeqNo: Int = 0

  /// Queue used to serialize accesses to `nextSeqNo`.
  private let incrementSequenceQueue = DispatchQueue(label: "Sequencer.lock")

  /// Sequence number of the last completed operation.
  private var lastReceivedSeqNo: Int?

  /// All currently ongoing operations.
  private var pendingOperations: [Int: Operation] = [:] {
    didSet {
      delegate?.didChangeOperationsState(hasPendingOperations: hasPendingOperations)
    }
  }

  /// Maximum number of pending operations allowed.
  /// If many operations are made in a short time, this will keep only the N most recent and cancel the older ones.
  /// This helps to avoid filling up the operation queue when the network is slow.
  /// Default value: 3
  var maxPendingOperationsCount: Int = 3

  /// Maximum number of concurrent sequencer completion operations allowed
  /// Default value: 5
  var maxConcurrentCompletionOperationsCount: Int = 5

  /// Indicates whether there are any pending operations.
  var hasPendingOperations: Bool {
    return !pendingOperations.filter { !($0.value.isCancelled || $0.value.isFinished) }.isEmpty
  }

  weak var delegate: SequencerDelegate?

  /// Queue containing SequencerCompletion operations
  private let sequencerQueue: OperationQueue

  init() {
    self.sequencerQueue = OperationQueue()
    self.sequencerQueue.maxConcurrentOperationCount = maxConcurrentCompletionOperationsCount
  }

  // MARK: - Sequencing logic

  /// Launch next operation.
  func orderOperation(operationLauncher: Sequencable.OperationLauncher) {
    // Increase sequence number.
    let currentSeqNo: Int = incrementSequenceQueue.sync {
      nextSeqNo += 1
      return nextSeqNo
    }

    // Cancel obsolete operations.
    pendingOperations
        .filter { $0.0 <= currentSeqNo - maxPendingOperationsCount }.keys
        .forEach(cancelOperation)

    let operation = operationLauncher()
    let sequencingOperation = SequencerCompletionOperation(sequenceNo: currentSeqNo, sequencer: self, correspondingOperation: operation)
    sequencingOperation.addDependency(operation)

    sequencerQueue.addOperation(sequencingOperation)

    pendingOperations[currentSeqNo] = operation
  }

  // MARK: - Manage operations

  /// Cancel all pending operations.
  func cancelPendingOperations() {
    for seqNo in pendingOperations.keys {
      cancelOperation(withSeqNo: seqNo)
    }
    assert(pendingOperations.isEmpty)
  }

  /// Cancel a specific operation.
  ///
  /// - parameter seqNo: The operation's sequence number.
  ///
  private func cancelOperation(withSeqNo seqNo: Int) {
    if let operation = pendingOperations[seqNo] {
      operation.cancel()
      pendingOperations.removeValue(forKey: seqNo)
    }
  }

  /// Clean-up after a succesful completion of a sequenced operation
  ///
  /// - parameter seqNo: The operation's sequence number.
  ///
  private func dismissOperation(withSeqNo seqNo: Int) {

    guard let operationToDismiss = pendingOperations[seqNo], !operationToDismiss.isCancelled else {
        return
    }

    // Remove the current operation.
    pendingOperations.removeValue(forKey: seqNo)

    // Obsolete operations should not happen since they have been cancelled by more recent operations (see above).
    // WARNING: Only works if the current queue is serial!
    assert(lastReceivedSeqNo == nil || lastReceivedSeqNo! < seqNo)

    // Update last received response.
    lastReceivedSeqNo = seqNo
  }

}

private extension Sequencer {

    class SequencerCompletionOperation: Operation {

        let sequenceNo: Int
        weak var sequencer: Sequencer?
        var correspondingOperation: Operation

        init(sequenceNo: Int, sequencer: Sequencer, correspondingOperation: Operation) {
            self.sequenceNo = sequenceNo
            self.sequencer = sequencer
            self.correspondingOperation = correspondingOperation
        }

        override func main() {
            guard
                let sequencer = sequencer,
                !correspondingOperation.isCancelled else { return }

            // Cancel all previous operations (as this one is deemed more recent).
            sequencer.pendingOperations
                .filter { $0.0 < sequenceNo }.keys
                .forEach(sequencer.cancelOperation)

            sequencer.dismissOperation(withSeqNo: sequenceNo)

        }

    }

}

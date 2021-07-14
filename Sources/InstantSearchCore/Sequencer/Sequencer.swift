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

    func orderOperation(operationLauncher: @escaping OperationLauncher)
    func cancelPendingOperations()
}

protocol SequencerDelegate: AnyObject {
  func didChangeOperationsState(hasPendingOperations: Bool)
}

class Sequencer: Sequencable {

  // MARK: Properties

  /// Sequence number for the next operation.
  private var nextSeqNo: Int = 0

  /// Queue used to serialize accesses to the Sequencer
  private let syncQueue = DispatchQueue(label: "AlgoliaSequencerSync.queue")

  /// Sequence number of the last completed operation.
  private var lastReceivedSeqNo: Int?

  /// All currently ongoing operations.
  private var pendingOperations: [Int: Operation] = [:] {
    didSet {
      syncQueue.async { [weak self] in
        guard let sequencer = self else { return }
        let hasPendingOperations = !sequencer.pendingOperations.values.filter { !($0.isCancelled || $0.isFinished) }.isEmpty
        sequencer.delegate?.didChangeOperationsState(hasPendingOperations: hasPendingOperations)
      }
    }
  }

  /// Indicates whether there are any pending operations.
  var hasPendingOperations: Bool {
    syncQueue.sync {
      !pendingOperations.values.filter { !$0.isCancelled || !$0.isFinished }.isEmpty
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

  weak var delegate: SequencerDelegate?

  /// Queue containing SequencerCompletion operations
  private let sequencerQueue: OperationQueue

  init() {
    self.sequencerQueue = OperationQueue()
    self.sequencerQueue.maxConcurrentOperationCount = maxConcurrentCompletionOperationsCount
  }

  // MARK: - Sequencing logic

  /// Launch next operation.
  func orderOperation(operationLauncher: @escaping Sequencable.OperationLauncher) {
    syncQueue.async { [weak self] in
      guard let sequencer = self else { return }

      // Increase sequence number
      sequencer.nextSeqNo += 1
      let currentSeqNo = sequencer.nextSeqNo

      // Launch sequenced operation
      let operation = operationLauncher()
      sequencer.pendingOperations[currentSeqNo] = operation

      // Create and launch completion operation
      let sequencingOperation = SequencerCompletionOperation(sequenceNo: currentSeqNo, sequencer: sequencer, correspondingOperation: operation)
      sequencingOperation.addDependency(operation)
      sequencer.sequencerQueue.addOperation(sequencingOperation)

      // Cancel obsolete operations
      let obsoleteOperations = sequencer.pendingOperations.filter { $0.0 <= currentSeqNo - sequencer.maxPendingOperationsCount }
      for (operationNo, operation) in  obsoleteOperations {
        InstantSearchCoreLogger.trace("Sequencer: cancel \(String(describing: operation.name)) as it seqNo \(operationNo) precedes min allowed \(currentSeqNo - sequencer.maxPendingOperationsCount)")
        operation.cancel()
        sequencer.pendingOperations.removeValue(forKey: operationNo)
      }
      InstantSearchCoreLogger.trace("Sequencer: sequenced \(String(describing: operation.name)) as \(currentSeqNo)")
    }
  }

  // MARK: - Manage operations

  /// Cancel all pending operations.
  func cancelPendingOperations() {
    syncQueue.async { [weak self] in
      guard let sequencer = self else { return }
      for (operationNo, operation) in sequencer.pendingOperations {
        operation.cancel()
        sequencer.pendingOperations.removeValue(forKey: operationNo)
      }
    }
  }

  /// Clean-up after a succesful completion of a sequenced operation
  ///
  /// - parameter seqNo: The operation's sequence number.
  ///
  private func dismissOperation(forSeqNo seqNo: Int) {
    syncQueue.async { [weak self] in
      guard let sequencer = self else { return }

      InstantSearchCoreLogger.trace("Sequencer: Dismiss \(seqNo)")

      // Cancel all preceding operations (as this one is deemed more recent).
      let precedingOperations = sequencer.pendingOperations.filter { $0.0 < seqNo }
      for (operationNo, operation) in precedingOperations {
        InstantSearchCoreLogger.trace("Sequencer: Cancel \(String(describing: operation.name)) as preceding to \(seqNo)")
        operation.cancel()
        sequencer.pendingOperations.removeValue(forKey: operationNo)
      }

      // Remove the current operation.
      sequencer.pendingOperations.removeValue(forKey: seqNo)

      // Update last received response.
      sequencer.lastReceivedSeqNo = seqNo
    }

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
            sequencer.dismissOperation(forSeqNo: sequenceNo)
        }

    }

}

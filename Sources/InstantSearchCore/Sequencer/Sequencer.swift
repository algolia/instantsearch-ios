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

protocol SequencerDelegate: class {
  func didChangeOperationsState(hasPendingOperations: Bool)
}

class Sequencer: Sequencable {

  // MARK: Properties

  /// Sequence number for the next operation.
  private var nextSeqNo: Int = 0

  /// Queue used to serialize accesses to `nextSeqNo`.
  private let incrementSequenceQueue = DispatchQueue(label: "Sequencer.lock")

  /// Queue used to serialize accesses to the Sequencer
  private let syncQueue = DispatchQueue(label: "AlgoliaSequencerSync.queue")

  /// Sequence number of the last completed operation.
  private var lastReceivedSeqNo: Int?

  /// All currently ongoing operations.
  private var pendingOperations: [Int: Operation] = [:] {
    didSet {
      syncQueue.async { [weak self] in
        guard let sequencer = self else { return }
        let hasPendingOperations = !sequencer.pendingOperations.filter { !($0.value.isCancelled || $0.value.isFinished) }.isEmpty
        sequencer.delegate?.didChangeOperationsState(hasPendingOperations: hasPendingOperations)
      }
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
        let operation = operationLauncher()
        // Increase sequence number.
        let currentSeqNo: Int = incrementSequenceQueue.sync {
          nextSeqNo += 1
          return nextSeqNo
        }

        // Cancel obsolete operations.
        pendingOperations
            .filter { $0.0 <= currentSeqNo - maxPendingOperationsCount }
            .keys
            .forEach(cancelOperation)

        let sequencingOperation = SequencerCompletionOperation(sequenceNo: currentSeqNo, sequencer: self, correspondingOperation: operation)
        sequencingOperation.addDependency(operation)
    
        syncQueue.async { [weak self] in
            guard let sequencer = self else { return }
            sequencer.sequencerQueue.addOperation(sequencingOperation)
            sequencer.pendingOperations[currentSeqNo] = operation
        }
  }

  // MARK: - Manage operations

  /// Cancel all pending operations.
  func cancelPendingOperations() {
    syncQueue.async { [weak self] in
        guard let sequencer = self else { return }
        for seqNo in sequencer.pendingOperations.keys {
          sequencer.cancelOperation(withSeqNo: seqNo)
        }
    }
  }

  /// Cancel a specific operation.
  ///
  /// - parameter seqNo: The operation's sequence number.
  ///
  private func cancelOperation(withSeqNo seqNo: Int) {
    syncQueue.async { [weak self] in
        guard let sequencer = self else { return }
        if let operation = sequencer.pendingOperations[seqNo] {
          operation.cancel()
          sequencer.pendingOperations.removeValue(forKey: seqNo)
        }
    }
  }

  /// Clean-up after a succesful completion of a sequenced operation
  ///
  /// - parameter seqNo: The operation's sequence number.
  ///
  private func dismissOperation(withSeqNo seqNo: Int) {
    syncQueue.async { [weak self] in
        guard let sequencer = self else { return }
        guard let operationToDismiss = sequencer.pendingOperations[seqNo], !operationToDismiss.isCancelled else {
            return
        }

        // Remove the current operation.
        sequencer.pendingOperations.removeValue(forKey: seqNo)

        // Obsolete operations should not happen since they have been cancelled by more recent operations (see above).
        // WARNING: Only works if the current queue is serial!
        assert(sequencer.lastReceivedSeqNo == nil || sequencer.lastReceivedSeqNo! < seqNo)

        // Update last received response.
        sequencer.lastReceivedSeqNo = seqNo
    }
  }
  
  // Cancel all previous operations (as this one is deemed more recent).
  private func cancelPreviousPendingOperations(beforeSeqNo seqNo: Int) {
    syncQueue.async { [weak self] in
      guard let sequencer = self else { return }
      let previousOperations = sequencer.pendingOperations.filter { $0.0 < seqNo }.values
      for operation in previousOperations {
        operation.cancel()
        sequencer.pendingOperations.removeValue(forKey: seqNo)
      }
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

            sequencer.cancelPreviousPendingOperations(beforeSeqNo: sequenceNo)
            sequencer.dismissOperation(withSeqNo: sequenceNo)
        }

    }

}

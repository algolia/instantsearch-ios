import Foundation

/// `Debouncer` helps in reducing the frequency of execution for a given set of operations.
/// It ensures that a function does not get called until after a certain amount of time has passed
/// since the last time it was called. This is especially useful for actions that get triggered often,
/// like UI input events, to avoid unnecessary work and improve performance.
///
/// Type parameter `T` is the type of the value you're monitoring. It should be `Equatable` to check
/// for changes.
///
/// Usage:
///
/// ```swift
/// let debouncer = Debouncer<String>(delay: 0.5)
/// searchBar.onChange = { searchText in
///     debouncer.debounce(value: searchText) { debouncedSearchText in
///         // perform an action with debouncedSearchText
///     }
/// }
/// ```
class Debouncer<T: Equatable> {
  /// The delay, in seconds, after which the action should be taken.
  private let delay: TimeInterval
  /// Keeps track of the last value passed to the `debounce` function.
  private var lastValue: T?
  /// The work item that's scheduled to run after the debounce delay.
  private var workItem: DispatchWorkItem?
  /// The execute queue of the completion block.
  private var queue: DispatchQueue

  /// Initializes a new debouncer with the given delay.
  ///
  /// - Parameter delay: The amount of time to wait before executing the action.
  /// - Parameter queue: The execute queue of the completion block.
  init(delay: TimeInterval,
       queue: DispatchQueue = .main) {
    self.delay = delay
    self.queue = queue
  }

  /// Debounces the execution of a function.
  ///
  /// If this method is called again with the same value before the delay has elapsed,
  /// the previously scheduled work will be canceled, effectively "debouncing" the calls.
  ///
  /// - Parameters:
  ///   - value: The new value to check against the previous one.
  ///   - completion: The completion block to execute after the delay, if the value has changed.
  func debounce(value: T, completion: @escaping (T) -> Void) {
    // Cancel the previously scheduled work item if it hasn't run yet
    workItem?.cancel()
    // If the new value is different from the last one, schedule the completion block to run after the delay
    if lastValue != value {
      lastValue = value

      workItem = DispatchWorkItem { [weak self] in
        self?.lastValue = nil
        completion(value)
      }

      queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
  }
}

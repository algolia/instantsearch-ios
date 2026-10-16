//
//  Error+Cancellation.swift
//  InstantSearchCore
//

import AlgoliaCore
import Foundation

extension Error {
  /// Whether the error is the outcome of an explicitly cancelled request rather than an actual failure.
  ///
  /// When a search operation is cancelled (e.g. superseded by a more recent search), the task running the
  /// network request is cancelled. Depending on the stage at which it happens, the API client surfaces it either as:
  /// - a `CancellationError`
  /// - a `URLError` with the `.cancelled` code
  /// - an `AlgoliaError.requestError` wrapping such a `URLError`
  /// - an `AlgoliaError.noReachableHosts` whose intermediate errors contain such a cancellation: the cancelled task
  ///   fails immediately on every host of the retry strategy, which marks all of them as unreachable.
  ///
  /// None of these should be reported as a search error.
  var isCancellation: Bool {
    switch self {
    case is CancellationError:
      return true
    case let urlError as URLError:
      return urlError.code == .cancelled
    case let .requestError(underlyingError) as AlgoliaError:
      return underlyingError.isCancellation
    case let .noReachableHosts(intermediateErrors, _) as AlgoliaError:
      return intermediateErrors.contains { $0.isCancellation }
    default:
      return false
    }
  }
}

//
//  SearchBoxObservableController.swift
//
//
//  Created by Vladislav Fitc on 29/03/2021.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
import InstantSearchTelemetry
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
  import Combine
  import SwiftUI

  /// SearchBoxController implementation adapted for usage with SwiftUI views
  @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
  public class SearchBoxObservableController: ObservableObject, SearchBoxController {
    /// Textual query
    @Published public var query: String

    public var onQueryChanged: ((String?) -> Void)?

    public var onQuerySubmitted: ((String?) -> Void)?

    private var querySubscription: AnyCancellable?

    public func setQuery(_ query: String?) {
      guard query != self.query else { return }
      self.query = query ?? ""
    }

    public init(query: String = "") {
      self.query = query
      InstantSearchTelemetry.shared.traceDeclarative(type: .searchBox)
      querySubscription = $query.removeDuplicates().sink { [weak self] value in
        self?.onQueryChanged?(value)
      }
    }

    /// Trigger query submit event
    public func submit() {
      onQuerySubmitted?(query)
    }

  }

  /// QueryInputController implementation adapted for usage with SwiftUI views
  @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
  @available(*, deprecated, renamed: "SearchBoxObservableController")
  public typealias QueryInputObservableController = SearchBoxObservableController
#endif

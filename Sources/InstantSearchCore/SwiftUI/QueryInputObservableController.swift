//
//  QueryInputObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// QueryInputController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class QueryInputObservableController: ObservableObject, QueryInputController {

  /// Textual query
  @Published public var query: String {
    didSet {
      onQueryChanged?(query)
    }
  }

  public var onQueryChanged: ((String?) -> Void)?

  public var onQuerySubmitted: ((String?) -> Void)?

  public func setQuery(_ query: String?) {
    self.query = query ?? ""
  }

  public init(query: String = "") {
    self.query = query
  }

  /// Trigger query submit event
  public func submit() {
    onQuerySubmitted?(query)
  }

}
#endif

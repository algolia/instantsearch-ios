//
//  RelevantSortObservableController.swift
//  
//
//  Created by Vladislav Fitc on 04/07/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// RelevantSortController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class RelevantSortObservableController: ObservableObject, RelevantSortController {

  /// Textual representation of the current sort state in the virtual replica
  @Published public var state: RelevantSortTextualRepresentation?

  public var didToggle: (() -> Void)?

  public init() {}

  public func setItem(_ state: RelevantSortTextualRepresentation?) {
    self.state = state
  }

  /// Toggle the relevant sort state (relevancy <-> hits count)
  public func toggle() {
    didToggle?()
  }

}

#endif

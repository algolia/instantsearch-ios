//
//  FilterClearObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
import InstantSearchTelemetry
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// FilterClearController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class FilterClearObservableController: ObservableObject, FilterClearController {

  public var onClick: (() -> Void)?

  /// Perform the filter cleaning
  public func clear() {
    onClick?()
  }

  public init() {
    Telemetry.shared.traceDeclarative(type: .filterClear)
  }

}
#endif

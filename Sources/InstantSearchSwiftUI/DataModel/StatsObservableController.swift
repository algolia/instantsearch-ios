//
//  StatsObservableController.swift
//
//
//  Created by Vladislav Fitc on 29/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// StatsController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class StatsObservableController: ObservableObject, ItemController {

  /// Textual representation of the stats
  @Published public var stats: SearchStats

  public func setItem(_ stats: SearchStats?) {
    if let stats = stats {
      self.stats = stats
    }
  }

  public init(stats: SearchStats = .init()) {
    self.stats = stats
  }

}

#endif

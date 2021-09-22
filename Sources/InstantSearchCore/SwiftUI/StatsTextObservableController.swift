//
//  StatsTextObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// StatsTextController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class StatsTextObservableController: ObservableObject, StatsTextController {

  /// Textual representation of the stats
  @Published public var stats: String

  public func setItem(_ stats: String?) {
    self.stats = stats ?? ""
  }

  public init(stats: String = "") {
    self.stats = stats
  }

}
#endif

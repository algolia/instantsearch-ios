//
//  HitsObservableController.swift
//  
//
//  Created by Vladislav Fitc on 26/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// HitsController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class HitsObservableController<Hit: Codable>: ObservableObject, HitsController {

  /// List of hits itemsto present
  @Published public var hits: [Hit?]

  /// The state ID to assign to the scrollview presenting the hits
  @Published public var scrollID: UUID

  public var hitsSource: HitsInteractor<Hit>?

  public func scrollToTop() {
    scrollID = .init()
  }

  public func reload() {
    self.hits = hitsSource?.hits ?? []
  }

  /// Function to call on hit appearance  to ensure the infinite scrolling functionality
  public func notifyAppearanceOfHit(atIndex index: Int) {
    hitsSource?.notifyDidPresentRow(atIndex: index)
  }

  public init() {
    self.hits = []
    self.scrollID = .init()
  }

}
#endif

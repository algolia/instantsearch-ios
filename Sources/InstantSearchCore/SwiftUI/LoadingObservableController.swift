//
//  LoadingObservableController.swift
//  
//
//  Created by Vladislav Fitc on 01/06/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// LoadingController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class LoadingObservableController: ObservableObject, LoadingController {

  /// The Boolean state defining if the loading is in progress
  @Published public var isLoading: Bool

  public func setItem(_ isLoading: Bool) {
    self.isLoading = isLoading
  }

  public init(isLoading: Bool = false) {
    self.isLoading = isLoading
  }

}

#endif

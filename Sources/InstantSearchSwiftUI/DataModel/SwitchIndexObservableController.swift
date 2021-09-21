//
//  SwitchIndexObservableController.swift
//  
//
//  Created by Vladislav Fitc on 01/04/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// SwitchIndexController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class SwitchIndexObservableController: ObservableObject, SwitchIndexController {

  /// List of available indices names
  @Published public var indicesNames: [IndexName]

  /// Name of the currently selected index
  @Published public var selectedIndexName: IndexName

  public var selectIndexWithName: (IndexName) -> Void = { _ in }

  public func set(indicesNames: [IndexName], selected: IndexName) {
    self.indicesNames = indicesNames
    self.selectedIndexName = selected
  }

  public init(indicesNames: [IndexName] = [],
              selected: IndexName = "") {
    self.indicesNames = indicesNames
    self.selectedIndexName = selected
  }

}
#endif

//
//  SelectableSegmentObservableController.swift
//  
//
//  Created by Vladislav Fitc on 04/07/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
/// SelectableSegmentController implementation adapted for usage with SwiftUI views
public class SelectableSegmentObservableController: ObservableObject, SelectableSegmentController {

  /// Textual titles of the available segments
  @Published public var segmentsTitles: [String]

  /// Index of the selected segment
  @Published public var selectedSegmentIndex: Int?

  public var onClick: ((Int) -> Void)?

  public func setSelected(_ selected: Int?) {
    selectedSegmentIndex = selected
  }

  public func setItems(items: [Int: String]) {
    segmentsTitles = items.sorted { $0.key < $1.key }.map(\.value)
  }

  /// Perform the selection of the segment at the provided index
  public func select(_ segmentIndex: Int) {
    onClick?(segmentIndex)
  }

  public init(segmentTitles: [String] = [],
              selectedSegmentIndex: Int? = nil) {
    self.segmentsTitles = segmentTitles
    self.selectedSegmentIndex = selectedSegmentIndex
  }

}
#endif

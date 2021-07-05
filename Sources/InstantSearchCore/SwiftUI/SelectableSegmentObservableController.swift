//
//  SelectableSegmentObservableController.swift
//  
//
//  Created by Vladislav Fitc on 04/07/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class SelectableSegmentObservableController: ObservableObject, SelectableSegmentController {
  
  @Published public var segmentsTitles: [String]
  @Published public var selectedSegmentIndex: Int?
  
  public var onClick: ((Int) -> Void)?
  
  public func setSelected(_ selected: Int?) {
    selectedSegmentIndex = selected
  }
  
  public func setItems(items: [Int : String]) {
    segmentsTitles = items.sorted { $0.key < $1.key }.map(\.value)
  }
  
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

//
//  SwitchIndexObservableController.swift
//  
//
//  Created by Vladislav Fitc on 01/04/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class SwitchIndexObservableController: ObservableObject, SwitchIndexController {

  @Published public var indexNames: [IndexName]
  @Published public var selected: IndexName

  public var select: (IndexName) -> Void = { _ in }

  public func set(indexNames: [IndexName], selected: IndexName) {
    self.indexNames = indexNames
    self.selected = selected
  }

  public init(indexNames: [IndexName] = [],
              selected: IndexName = "") {
    self.indexNames = indexNames
    self.selected = selected
  }

}

//
//  SwitchIndexObservableController.swift
//  
//
//  Created by Vladislav Fitc on 01/04/2021.
//

import Foundation

public class SwitchIndexObservableController: ObservableObject, SwitchIndexController {
  
  @Published public var indexNames: [IndexName] = []
  @Published public var selected: IndexName = ""
  
  public var select: (IndexName) -> Void = { _ in }
  
  public func set(indexNames: [IndexName], selected: IndexName) {
    self.indexNames = indexNames
    self.selected = selected
  }
  
  public init() {}
      
}

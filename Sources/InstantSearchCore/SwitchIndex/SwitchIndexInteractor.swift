//
//  SwitchIndexInteractor.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

public class SwitchIndexInteractor {

  var indexNames: [IndexName]

  var selectedIndexName: IndexName {
    didSet {
      guard oldValue != selectedIndexName else { return }
      onSelectionChange.fire(selectedIndexName)
    }
  }

  var onSelectionChange: Observer<IndexName>

  public init(indexNames: [IndexName], selectedIndexName: IndexName) {
    assert(indexNames.contains(selectedIndexName))
    self.indexNames = indexNames
    self.selectedIndexName = selectedIndexName
    self.onSelectionChange = .init()
  }

}

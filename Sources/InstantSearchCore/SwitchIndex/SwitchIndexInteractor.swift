//
//  SwitchIndexInteractor.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

/// Business logic component that handles the index name switching
public class SwitchIndexInteractor {

  /// List of available indices names
  public var indexNames: [IndexName]

  /// Name of the currently selected index
  public var selectedIndexName: IndexName {
    didSet {
      guard oldValue != selectedIndexName else { return }
      onSelectionChange.fire(selectedIndexName)
    }
  }

  /// Triggered when index name changed
  /// - Parameter: a selected index name
  public var onSelectionChange: Observer<IndexName>

  /**
   - Parameters:
     - indexNames: List of names of available indices
     - selectedIndexName: Name of the currently selected index
   */
  public init(indexNames: [IndexName],
              selectedIndexName: IndexName) {
    assert(indexNames.contains(selectedIndexName))
    self.indexNames = indexNames
    self.selectedIndexName = selectedIndexName
    self.onSelectionChange = .init()
  }

}

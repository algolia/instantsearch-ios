//
//  SwitchIndexInteractor.swift
//
//
//  Created by Vladislav Fitc on 08/04/2021.
//
import Foundation

@available(*, deprecated, message: "Use SortByInteractor instead")
public class SwitchIndexInteractor {
  public var indexNames: [String]

  public var selectedIndexName: String {
    didSet {
      guard oldValue != selectedIndexName else { return }
      onSelectionChange.fire(selectedIndexName)
    }
  }

  public var onSelectionChange: Observer<String>

  public init(indexNames: [String], selectedIndexName: String) {
    assert(indexNames.contains(selectedIndexName))
    self.indexNames = indexNames
    self.selectedIndexName = selectedIndexName
    onSelectionChange = .init()
  }
}

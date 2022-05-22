//
//  FilterStateObservableController.swift
//  Examples
//
//  Created by Vladislav Fitc on 06.04.2022.
//

import Foundation
import UIKit
import InstantSearch

class FilterStateObservableController: ObservableObject {

  @Published public var filtersString: String
  private let emptyMessage = "No filters applied"

  public init(filterState: FilterState) {
    filtersString = emptyMessage
    filterState.onChange.subscribePast(with: self) { viewController, _ in
      let sqlString = filterState.toFilterGroups().sqlFormWithSyntaxHighlighting(colorMap: [:]).string
      viewController.filtersString = sqlString.isEmpty ? viewController.emptyMessage : sqlString
    }
  }

}

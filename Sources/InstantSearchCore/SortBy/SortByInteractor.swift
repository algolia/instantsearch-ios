//
//  SortByInteractor.swift
//
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation

public class SortByInteractor: SelectableSegmentInteractor<Int, String> {
  override public init(items: [Int: String], selected: Int? = .none) {
    super.init(items: items, selected: selected)
    Telemetry.shared.trace(type: .sortBy,
                           parameters: [
                             selected == nil ? .none : .selected
                           ])
  }
}

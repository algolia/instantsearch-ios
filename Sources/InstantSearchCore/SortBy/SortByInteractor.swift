//
//  SortByInteractor.swift
//  
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation
import AlgoliaSearchClient

public class SortByInteractor: SelectableSegmentInteractor<Int, IndexName> {

  public override init(items: [Int: IndexName], selected: Int? = .none) {
    super.init(items: items, selected: selected)
    Telemetry.shared.trace(type: .sortBy,
                           parameters: [
                             selected == nil ? .none : .selected
                           ])
  }

}

//
//  SelectableListInteractor+Filter.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterListInteractor<F: FilterType & Hashable>: SelectableListInteractor<F, F> {
  
  public override init(items: [F] = [], selectionMode: SelectionMode) {
    super.init(items: items, selectionMode: selectionMode)
    switch F.self {
    case is FacetFilter.Type:
      Telemetry.shared.track(type: .facetFilterList,
                             parameters: [.selectionMode],
                             useConnector: false)

    case is NumericFilter.Type:
      Telemetry.shared.track(type: .numericFilterList,
                             parameters: [.selectionMode],
                             useConnector: false)

    case is TagFilter.Type:
      Telemetry.shared.track(type: .tagFilterList,
                             parameters: [.selectionMode],
                             useConnector: false)

    default:
      break
    }
  }
    
}

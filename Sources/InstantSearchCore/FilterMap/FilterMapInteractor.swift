//
//  FilterMapInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterMapInteractor<Filter: FilterType>: SelectableSegmentInteractor<Int, Filter> {

  public override init(items: [Int: Filter], selected: Int? = .none) {
    super.init(items: items,
               selected: selected)
    Telemetry.shared.trace(type: .filterMap,
                           parameters: [
                            selected == nil ? .none : .selected
                           ])
  }

}

@available(*, deprecated, renamed: "FilterMapInteractor")
typealias SelectableFilterInteractor = FilterMapInteractor

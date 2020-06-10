//
//  FilterStateDSL.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 15/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterStateDSL {

  var filters: FiltersReadable & FiltersWritable & FilterGroupsConvertible

  public init() {
    self.filters = GroupsStorage()
  }

}

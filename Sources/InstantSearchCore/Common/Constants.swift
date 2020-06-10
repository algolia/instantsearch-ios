//
//  Constants.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 07/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct Constants {
  public struct Defaults {

    // Hits
    public static let hitsPerPage: UInt = 20
    public static let infiniteScrolling: InfiniteScrolling = .on(withOffset: 5)
    public static let showItemsOnEmptyQuery: Bool = true

    // Refinement
    public static let operatorRefinement = "or"
    public static let refinementOperator: RefinementOperator = .or
    public static let refinedFirst = true

    public static let limit = 10
    public static let areMultipleSelectionsAllowed = false
  }
}

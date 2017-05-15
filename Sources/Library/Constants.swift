//
//  Constants.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/05/2017.
//
//

import Foundation

struct Constants {
    struct Defaults {
        
        // Hits
        
        static let hitsPerPage: UInt = 20
        static let infiniteScrolling: Bool = true
        static let remainingItemsBeforeLoading: UInt = 5
        
        // Refinement
        
        static let attribute = ""
        static let refinedFirst = true
        static let `operator` = "or"
        static let sortBy = "count:desc"
        static let limit = 10
        
        // Numeric Control
    }
}

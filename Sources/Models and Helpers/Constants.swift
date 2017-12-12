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
        
        // Multi Index
        static let index: String = ""
        static let variant: String = ""
        
        // Hits
        static let hitsPerPage: UInt = 20
        static let infiniteScrolling: Bool = true
        static let remainingItemsBeforeLoading: UInt = 5
        static let showItemsOnEmptyQuery: Bool = true
        
        // Refinement, Numeric Control, Facet Control
        static let attribute = ""
        
        // Numeric Control, Facet Control
        static let inclusive = true
        
        // Refinement
        static let operatorRefinement = "or"
        static let refinedFirst = true
        static let sortBy = "count:desc"
        static let limit = 10
        
        // Numeric Control
        static let operatorNumericControl = ">="
        
        // Facet Control
        static let valueOn = "true"
        static let valueOff = "false"
        
        // Stats
        
        static let resultTemplate = "{nbHits} results"
        static let errorText = "Error in fetching results"
        static let clearText = ""
    }
}

//
//  SearchableViewModel.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

/// Protocol that gives a reference to the Searcher associated with InstantSearch.
@objc public protocol SearchableViewModel: class {
    
    /// Configures the ViewModel with the reference to the Searcher associated with InstantSearch.
    /// This is used in the base of single index
    func configure(with searcher: Searcher)
}

@objc public protocol SearchableMultiIndexViewModel: SearchableViewModel {
    /// Configures the ViewModel with the reference to the Searchers associated with InstantSearch.
    /// This is used in the case of multi-index
    @objc optional func configure(withSearchers searchers: [Searcher])
    
    /// The index name extracted from the view. Note that this is immutable, with the source of truth coming from the view only.
    var indexName: String { get }
    
    /// The index id extracted from the view. Note that this is immutable, with the source of truth coming from the view only.
    var indexId: String { get }
}

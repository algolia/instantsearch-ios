//
//  SearchableViewModel.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc public protocol AlgoliaViewModel: class {}

/// Protocol that gives a reference to the Searcher associated with InstantSearch.
@objc public protocol SearchableViewModel: AlgoliaViewModel {
    
    /// Configures the ViewModel with the reference to the Searcher associated with InstantSearch.
    /// This is used in the base of single index
    func configure(with searcher: Searcher)
}

@objc public protocol MultiSearchableViewModel: AlgoliaViewModel {
    /// Configures the ViewModel with the reference to the Searchers associated with InstantSearch.
    /// This is used in the case of multi-index
    func configure(withSearchers searchers: [Searcher])
}

@objc public protocol SearchableIndexViewModel: SearchableViewModel {
    /// The index name extracted from the view. Note that this is immutable, with the source of truth coming from the view only.
    var indexName: String { get }
    
    /// The index id extracted from the view. Note that this is immutable, with the source of truth coming from the view only.
    var indexId: String { get }
}

@objc public protocol SearchableMultiIndexViewModel: MultiSearchableViewModel {

    /// The index name extracted from the view. Note that this is immutable, with the source of truth coming from the view only.
    var indexNamesArray: [String] { get }
    
    /// The index id extracted from the view. Note that this is immutable, with the source of truth coming from the view only.
    var indexIdsArray: [String] { get }
}

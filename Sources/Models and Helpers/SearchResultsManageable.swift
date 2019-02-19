//
//  SearchResultsManageable.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 18/02/2019.
//

import Foundation

public protocol SearchResultsManageable {
    
    var indexName: String { get }
    var variant: String { get }
    var params: InstantSearchCore.SearchParameters { get }
    var results: InstantSearchCore.SearchResults? { get }
    func loadMore()
    
}

extension SearchResultsManageable {
    
    var hits: [[String: Any]] {
        return results?.allHits ?? []
    }
    
}

extension Searcher: SearchResultsManageable {}

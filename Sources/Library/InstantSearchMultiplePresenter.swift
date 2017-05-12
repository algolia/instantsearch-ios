//
//  InstantSearchMultiplePresenter.swift
//  ecommerce
//
//  Created by Guy Daher on 14/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc public class InstantSearchMultiplePresenter: NSObject {
    @objc var instantSearchPresenters: [InstantSearch] = []
    
//    @objc init(searcher: Searcher) {
//        instantSearchPresenters = [InstantSearch(searcher: searcher)]
//    }
//
//    @objc public func add(searcher: Searcher) {
//        instantSearchPresenters.append(InstantSearch(searcher: searcher))
//    }
    
    internal func searchInAllPresenters(searchText: String) {
        for instantSearchPresenter in instantSearchPresenters {
            instantSearchPresenter.search(with: searchText)
        }
    }
}

extension InstantSearchMultiplePresenter: UISearchResultsUpdating {
    
    @objc public func add(searchController: UISearchController) {
        searchController.searchResultsUpdater = self
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        searchInAllPresenters(searchText: searchText)
    }
}

extension InstantSearchMultiplePresenter: UISearchBarDelegate {
    @objc public func add(searchBar: UISearchBar) {
        searchBar.delegate = self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInAllPresenters(searchText: searchText)
    }
}

//
//  InstantSearchMultiplePresenter.swift
//  ecommerce
//
//  Created by Guy Daher on 14/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc class InstantSearchMultiplePresenter: NSObject {
    @objc var instantSearchPresenters: [InstantSearchBinder] = []
    
    @objc init(searcher: Searcher) {
        instantSearchPresenters = [InstantSearchBinder(searcher: searcher)]
    }
    
    @objc public func add(searcher: Searcher) {
        instantSearchPresenters.append(InstantSearchBinder(searcher: searcher))
    }
    
    internal func searchInAllPresenters(searchText: String) {
        for instantSearchPresenter in instantSearchPresenters {
            instantSearchPresenter.searchInPresenter(searchText: searchText)
        }
    }
}

extension InstantSearchMultiplePresenter: UISearchResultsUpdating {
    
    @objc public func add(searchController: UISearchController) {
        searchController.searchResultsUpdater = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        searchInAllPresenters(searchText: searchText)
    }
}

extension InstantSearchMultiplePresenter: UISearchBarDelegate {
    @objc public func add(searchBar: UISearchBar) {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInAllPresenters(searchText: searchText)
    }
}

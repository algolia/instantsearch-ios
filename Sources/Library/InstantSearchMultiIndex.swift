//
//  InstantSearchMultiplePresenter.swift
//  ecommerce
//
//  Created by Guy Daher on 14/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

/// Manages Multiple InstantSearch references.
/// It also takes care of managing search components: `UISearchBar` and `UISearchController`.
@objc public class InstantSearchMultiIndex: NSObject {
    var instantSearchRefs: [InstantSearch]
    
    @objc init(instantSearch: InstantSearch) {
        self.instantSearchRefs = [instantSearch]
    }
    
    @objc init(instantSearchRefs: [InstantSearch]) {
        self.instantSearchRefs = instantSearchRefs
    }
    
    @objc public func add(instantSearch: InstantSearch) {
        instantSearchRefs.append(instantSearch)
    }
    
    @objc public func add(instantSearchRef: [InstantSearch]) {
        instantSearchRefs.append(contentsOf: instantSearchRefs)
    }
    
    func searchInAllInstantSearchRefs(with searchText: String) {
        for instantSearchRef in instantSearchRefs {
            instantSearchRef.search(with: searchText)
        }
    }
}

extension InstantSearchMultiIndex: UISearchResultsUpdating {
    
    /// Forwards a `SearchController` to `InstantSearch` so that it takes care of updating search results
    /// on every new keystroke inside the `UISearchBar` linked to it.
    @objc public func add(searchController: UISearchController) {
        searchController.searchResultsUpdater = self
    }
    
    /// Handler called on each keystroke change in the `UISearchBar`
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        searchInAllInstantSearchRefs(with: searchText)
    }
    
    /// Handler called when searchBar becomes first responder
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        searchInAllInstantSearchRefs(with: searchText)
    }
}

extension InstantSearchMultiIndex: UISearchBarDelegate {
    /// Forwards a `UISearchBar` to `InstantSearch` so that it takes care of updating search results
    /// on every new keystroke
    @objc public func add(searchBar: UISearchBar) {
        searchBar.delegate = self
    }
    
    /// Handler called on each keystroke change in the `UISearchBar`
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInAllInstantSearchRefs(with: searchText)
    }
}

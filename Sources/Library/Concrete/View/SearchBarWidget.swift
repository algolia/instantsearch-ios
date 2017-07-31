//
//  SearchBarWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

/// Widget that provides a user input for search queries that are directly sent to the Algolia engine. Built on top of `UISearchBar`.
@objc public class SearchBarWidget: UISearchBar, SearchableViewModel, ResettableDelegate, AlgoliaWidget, UISearchBarDelegate {
    
    public var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        delegate = self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searcher.params.query = searchText
        searcher.search()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searcher.params.query = searchBar.text
        searcher.search()
    }
    
    public func onReset() {
        resignFirstResponder()
        text = ""
    }
}

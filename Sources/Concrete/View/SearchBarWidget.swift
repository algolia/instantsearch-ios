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
    
    public var searchers: [Searcher] = []
    
    @IBInspectable public var indexName: String = Constants.Defaults.indexName
    @IBInspectable public var indexId: String = Constants.Defaults.indexId
    
    public func configure(with searcher: Searcher) {
        self.searchers = [searcher]
        delegate = self
    }
    
    public func configure(withSearchers searchers: [Searcher]) {
        self.searchers = searchers
        delegate = self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for searcher in searchers {
            searcher.params.query = searchText
            searcher.search()
        }
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        for searcher in searchers {
            searcher.params.query = searchBar.text
            searcher.search()
        }
    }
    
    public func onReset() {
        resignFirstResponder()
        text = ""
    }
}

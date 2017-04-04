//
//  SearchBarWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

class SearchBarWidget: UISearchBar, AlgoliaWidget, UISearchBarDelegate {
    
    private var searcher: Searcher!
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        delegate = self
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searcher.params.query = searchText
        searcher.search()
    }
    
    func onReset() {
        text = ""
    }
}

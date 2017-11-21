//
//  SearchViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/11/2017.
//

import InstantSearchCore

/// ViewModel - View: StatsViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
internal class SearchViewModel: SearchControlViewModelDelegate, SearchableViewModel {
    
    // MARK: - Properties
    var indexId: String {
        return view.indexId
    }
    
    var indexName: String {
        return view.indexName
    }
    
    public var searchers: [Searcher] = []
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searchers = [searcher]
    }
    
    func configure(withSearchers searchers: [Searcher]) {
        self.searchers = searchers
    }
    
    // MARK: - StatsViewModelDelegate
    
    weak var view: SearchControlViewDelegate!
    
    /// search with a given query text
    func search(query: String?) {
        for searcher in searchers {
            searcher.params.query = query
            searcher.search()
        }
    }
}

extension SearchViewModel: ResettableDelegate {
    func onReset() {
        view.set(text: "", andResignFirstResponder: true)
    }
}

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
internal class SearchViewModel: SearchViewModelDelegate, SearchableViewModel {
    
    // MARK: - Properties
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
    
    weak var view: SearchViewDelegate!
    
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

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
internal class SearchViewModel: NSObject, SearchControlViewModelDelegate, SearchableIndexViewModel {
    
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
        configure(withSearchers: [searcher])
    }
    
    func configure(withSearchers searchers: [Searcher]) {
        self.searchers = searchers
        for searcher in self.searchers {
            searcher.params.addObserver(self, forKeyPath: "query", options: [.new, .old], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "query" {
            if let change = change, let newQuery = change[.newKey] as? String {
                view.set(text: newQuery, andResignFirstResponder: false)
            }
        }
    }
    
    // MARK: - SearchViewModelDelegate
    
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

//
//  SearchViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/11/2017.
//

import InstantSearchCore
import Foundation

/// ViewModel - View: StatsViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
internal class SearchViewModel: NSObject, SearchControlViewModelDelegate, SearchableIndexViewModel, MultiSearchableViewModel {
    
    // MARK: - Properties
    var indexId: String {
        return view.indexId
    }
    
    var indexName: String {
        return view.indexName
    }
    
    public var searchers: [Searcher] = []
    
    private var observations: [NSKeyValueObservation] = []
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        configure(withSearchers: [searcher])
    }
    
    func configure(withSearchers searchers: [Searcher]) {
        self.searchers = searchers
        for searcher in self.searchers {
            let observation = searcher.params.observe(\.query, changeHandler: { (searchparams, _) in
                if let query = searchparams.query {
                    self.view.set(text: query, andResignFirstResponder: false)
                }
            })
            observations.append(observation)
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

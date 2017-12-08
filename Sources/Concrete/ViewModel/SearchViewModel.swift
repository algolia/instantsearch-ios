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
public class SearchViewModel: NSObject, SearchControlViewModelDelegate, SearchableIndexViewModel, MultiSearchableViewModel {
    
    // MARK: - Properties
    public var searcherId: SearcherId {
        return SearcherId(index: view.index, variant: view.variant)
    }
    
    public var searchers: [Searcher] = []
    
    private var observations: [NSKeyValueObservation] = []
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        configure(withSearchers: [searcher])
    }
    
    public func configure(withSearchers searchers: [Searcher]) {
        self.searchers = searchers
        for searcher in self.searchers {
            let observation = searcher.params.observe(\.query, changeHandler: { [unowned self] (searchparams, _) in
                if let query = searchparams.query {
                    self.view.set(text: query, andResignFirstResponder: false)
                }
            })
            observations.append(observation)
        }
    }
    
    // MARK: - SearchViewModelDelegate
    
    public weak var view: SearchControlViewDelegate!
    
    override init() {
        super.init()
    }
    
    convenience public init(view: SearchControlViewDelegate) {
        self.init()
        self.view = view
    }
    
    /// search with a given query text
    public func search(query: String?) {
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

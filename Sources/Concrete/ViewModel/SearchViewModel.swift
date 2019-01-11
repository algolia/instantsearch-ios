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
@objcMembers public class SearchViewModel: NSObject, SearchControlViewModelDelegate, SearchableIndexViewModel, MultiSearchableViewModel {
    
    // MARK: - Properties
    private var _searcherId: SearcherId?

    public var searcherId: SearcherId {
        set {
            _searcherId = newValue
        } get {
            if let strongSearcherId = _searcherId { return strongSearcherId}

            if let view = view {
                return SearcherId(index: view.index, variant: view.variant)
            } else {
                print("ERROR - ViewModel not associated to any searcherId or View, so it cannot operate")
                return SearcherId(index: "")
            }
        }
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
        guard #available(iOS 11.0, *) else { return }
        for searcher in self.searchers {
            let observation = searcher.params.observe(\.query, changeHandler: { [unowned self] (searchparams, _) in
                if let query = searchparams.query {
                    self.view?.set(text: query, andResignFirstResponder: false)
                }
            })
            observations.append(observation)
        }
    }
    
    // MARK: - SearchViewModelDelegate
    
    public weak var view: SearchControlViewDelegate?
    
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
        view?.set(text: "", andResignFirstResponder: true)
    }
}

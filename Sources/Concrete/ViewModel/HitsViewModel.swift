//
//  HitsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 06/04/2017.
//
//

import Foundation
import InstantSearchCore

/// ViewModel - View: HitsViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
public class HitsViewModel: HitsViewModelDelegate, SearchableIndexViewModel {
    
    // MARK: - Properties
    
    public var searcherId: SearcherId {
        return SearcherId(index:  view.index, variant: view.variant)
    }
    
    public var hitsPerPage: UInt {
        return view.hitsPerPage
    }
    
    public var infiniteScrolling: Bool {
        return view.infiniteScrolling
    }
    
    public var remainingItemsBeforeLoading: UInt {
        return view.remainingItemsBeforeLoading
    }
    
    public var showItemsOnEmptyQuery: Bool {
        return view.showItemsOnEmptyQuery
    }
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        searcher.params.hitsPerPage = hitsPerPage
        
        if searcher.hits.isEmpty {
            view.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    public weak var view: HitsViewDelegate!
    
    init() { }
    
    public init(view: HitsViewDelegate) {
        self.view = view
    }
    
    public func numberOfRows() -> Int {
        guard let searcher = searcher else { return 0 }
        
        if showItemsOnEmptyQuery {
            return searcher.hits.count
        } else {
            if searcher.params.query == nil || searcher.params.query!.isEmpty {
                return 0
            } else {
                return searcher.hits.count
            }
        }
        
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        guard let searcher = searcher else { return [:]}
        
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return searcher.hits[indexPath.row]
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard let searcher = searcher else { return }
        guard infiniteScrolling else { return }
        
        if rowNumber + Int(remainingItemsBeforeLoading) >= searcher.hits.count {
            searcher.loadMore()
        }
    }
}

// MARK: - ResultingDelegate

extension HitsViewModel: ResultingDelegate {
    
    // MARK: - ResultingDelegate
    
    public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        
        guard let results = results else {
            print(error ?? "")
            return
        }
        
        view.reloadHits()
        
        if results.page == 0 && numberOfRows() > 0 {
            view.scrollTop()
        }
    }
}

extension HitsViewModel: ResettableDelegate {
    func onReset() {
        view.reloadHits()
    }
}

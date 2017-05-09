//
//  HitsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 06/04/2017.
//
//

import Foundation
import InstantSearchCore

/// ViewModel - View: HitsViewModelDelegate
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate
internal class HitsViewModel: HitsViewModelDelegate, SearchableViewModel {
    
    // MARK: - Properties
    
    var hitsPerPage: UInt {
        return view.hitsPerPage
    }
    
    var infiniteScrolling: Bool {
        return view.infiniteScrolling
    }
    
    var remainingItemsBeforeLoading: UInt {
        return view.remainingItemsBeforeLoading
    }
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        searcher.params.hitsPerPage = hitsPerPage
        
        if searcher.hits.count > 0 {
            view.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    weak var view: HitsViewDelegate!
    
    func numberOfRows() -> Int {
        guard let searcher = searcher else { return 0 }
        
        return searcher.hits.count
    }
    
    func hitForRow(at indexPath: IndexPath) -> [String: Any] {
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
    
    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        view.reloadHits()
        
        if results?.page == 0 {
            view.scrollTop()
        }
    }
}

extension HitsViewModel: ResettableDelegate {
    func onReset() {
        view.reloadHits()
    }
}

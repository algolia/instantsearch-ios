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
    
    var showItemsOnEmptyQuery: Bool {
        return view.showItemsOnEmptyQuery
    }
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        searcher.params.hitsPerPage = hitsPerPage
        
        if searcher.hits.isEmpty {
            view.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    weak var view: HitsViewDelegate!
    
    func numberOfRows() -> Int {
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
        
        guard let results = results else {
            print(error ?? "")
            return
        }
        
        view.reloadHits()
        
        if results.page == 0 {
            view.scrollTop()
        }
    }
}

extension HitsViewModel: ResettableDelegate {
    func onReset() {
        view.reloadHits()
    }
}

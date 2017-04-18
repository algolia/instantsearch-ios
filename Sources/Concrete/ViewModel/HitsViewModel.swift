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
    
    public var searcher: Searcher! {
        didSet {
            searcher.params.hitsPerPage = hitsPerPage
            
            if searcher.hits.count > 0 {
                view.reloadHits()
            }
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    weak var view: HitsViewDelegate!
    
    public func numberOfRows() -> Int {
        return searcher.hits.count
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return searcher.hits[indexPath.row]
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard infiniteScrolling else { return }
        if rowNumber + Int(remainingItemsBeforeLoading) >= searcher.hits.count {
            searcher.loadMore()
        }
    }
}

// MARK: - ResultingDelegate

extension HitsViewModel: ResultingDelegate {
    
    // MARK: - ResultingDelegate
    
    @objc public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        guard searcher.hits.count > 0 else { return }
        
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

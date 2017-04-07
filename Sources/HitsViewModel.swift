//
//  HitsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 06/04/2017.
//
//

import Foundation
import InstantSearchCore

class HitsViewModel: HitsViewModelDelegate, ResultingDelegate, SearchableViewModel {
    
    weak var view: HitsViewDelegate!
    
    public init() {}
    
    public var searcher: Searcher! {
        didSet {
            searcher.params.hitsPerPage = view.hitsPerPage
            
            if searcher.hits.count > 0 {
                view.reloadHits()
            }
        }
    }
    
    @objc public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        guard searcher.hits.count > 0 else { return }
        
        view.reloadHits()
        
        if results?.page == 0 {
            view.scrollTop()
        }
    }
    
    public func numberOfRows() -> Int {
        return searcher.hits.count
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return searcher.hits[indexPath.row]
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard view.infiniteScrolling else { return }
        if rowNumber + Int(view.remainingItemsBeforeLoading) >= searcher.hits.count {
            searcher.loadMore()
        }
    }
}

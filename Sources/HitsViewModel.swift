//
//  HitsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 06/04/2017.
//
//

import Foundation
import InstantSearchCore

class HitsViewModel: HitsViewModelDelegate, ResultingInterface, SearcherInterface {
    
    weak var view: HitsViewDelegate!
    
    public init() {}
    
    public var searcher: Searcher! {
        didSet {            
            view.initView()
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

@objc public protocol AlgoliaView: class {
    
}

/*
 * Protocol that defines the view input methods.
 */
@objc public protocol HitsViewDelegate: class {
    
    func initView()
    func reloadHits()
    func scrollTop()
    
    var hitsPerPage: UInt { get set }
    var infiniteScrolling: Bool { get set }
    var remainingItemsBeforeLoading: UInt { get set }
    
    var viewModel: HitsViewModelDelegate! { get set }
}

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol HitsViewModelDelegate: SearcherInterface {
    
    var view: HitsViewDelegate! { get set }
    
    func numberOfRows() -> Int
    func hitForRow(at indexPath: IndexPath) -> [String: Any]
}

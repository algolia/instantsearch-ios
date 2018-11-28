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
@objcMembers public class HitsViewModel: NSObject, HitsViewModelDelegate, SearchableIndexViewModel {
    
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

    // TODO: Those should be settable in the long run, same idea as when we do a private _var and var everywhere. Note that they can always create a virtual view that is not added to the UI, that has all the necessary properties set. 
    public var hitsPerPage: UInt {
        return view?.hitsPerPage ?? Constants.Defaults.hitsPerPage
    }
    
    public var infiniteScrolling: Bool {
        return view?.infiniteScrolling ?? Constants.Defaults.infiniteScrolling
    }
    
    public var remainingItemsBeforeLoading: UInt {
        return view?.remainingItemsBeforeLoading ?? Constants.Defaults.remainingItemsBeforeLoading
    }
    
    public var showItemsOnEmptyQuery: Bool {
        return view?.showItemsOnEmptyQuery ?? Constants.Defaults.showItemsOnEmptyQuery
    }
  
    public var params: SearchParameters {
        return searcher.params
    }
  
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        searcher.params.hitsPerPage = hitsPerPage
        
        if searcher.hits.isEmpty {
            view?.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    public weak var view: HitsViewDelegate?
    
    override init() { }
    
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
        
        view?.reloadHits()
        
        if results.page == 0 && numberOfRows() > 0 {
            view?.scrollTop()
        }
    }
}

extension HitsViewModel: ResettableDelegate {
    func onReset() {
        view?.reloadHits()
    }
}

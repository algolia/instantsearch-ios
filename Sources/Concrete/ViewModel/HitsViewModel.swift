//
//  HitsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 06/04/2017.
//
//

import Foundation
import InstantSearchCore
import InstantSearchInsights

/// ViewModel - View: HitsViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
@objcMembers public class HitsViewModel: NSObject, HitsViewModelDelegate, SearchableIndexViewModel {
    
    // MARK: - Properties

    private var _searcherId: SearcherId?

    public var searcherId: SearcherId {
        
        set {
            _searcherId = newValue
        }
        
        get {
            if let strongSearcherId = _searcherId { return strongSearcherId }

            if let view = view {
                return SearcherId(index: view.index, variant: view.variant)
            } else {
                print("ERROR - ViewModel not associated to any searcherId or View, so it cannot operate")
                return SearcherId(index: "")
            }
        }
        
    }
    
    public var queryID: String? {
        return resultsManager.results?.queryID
    }
    
    public var enableClickAnalytics: Bool {
        return view?.enableClickAnalytics ?? Constants.Defaults.enableClickAnalytics
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
        return resultsManager.params
    }
    
    public var hitClickEventName: String? {
        return view?.hitClickEventName
    }
  
    // MARK: - SearchableViewModel
    
    var resultsManager: SearchResultsManageable!
    
    public func configure(with resultsManager: SearchResultsManageable) {
        self.resultsManager = resultsManager
        
        resultsManager.params.hitsPerPage = hitsPerPage
        
        if resultsManager.hits.isEmpty {
            view?.reloadHits()
        }
    }
    
    public func configure(with searcher: Searcher) {
        self.resultsManager = searcher
        
        resultsManager.params.hitsPerPage = hitsPerPage
        
        if resultsManager.hits.isEmpty {
            view?.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    public weak var view: HitsViewDelegate?
    public weak var clickAnalyticsDelegate: ClickAnalyticsDelegate? = Insights.shared
    
    override init() { }
    
    public init(view: HitsViewDelegate) {
        self.view = view
    }
    
    public func numberOfRows() -> Int {
        guard let resultsManager = resultsManager else { return 0 }
        
        if showItemsOnEmptyQuery {
            return resultsManager.hits.count
        } else {
            if resultsManager.params.query == nil || resultsManager.params.query!.isEmpty {
                return 0
            } else {
                return resultsManager.hits.count
            }
        }
        
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        guard let resultsManager = resultsManager else { return [:]}
        
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return resultsManager.hits[indexPath.row]
    }
    
    public func captureClickAnalyticsForHit(at indexPath: IndexPath) {
        
        guard enableClickAnalytics else { return }
        
        let hit = hitForRow(at: indexPath)
        let position = indexPath.row + 1
        
        let indexName: String
        
        if let viewIndexName = view?.index, viewIndexName.isEmpty {
            indexName = viewIndexName
        } else {
            indexName = resultsManager.indexName
        }
        
        if
            let queryID = queryID,
            let eventName = view?.hitClickEventName,
            let objectID = hit["objectID"] as? String {
            clickAnalyticsDelegate?.clickedAfterSearch(eventName: eventName,
                                                       indexName: indexName,
                                                       objectID: objectID,
                                                       position: position,
                                                       queryID: queryID)
        }

    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard let resultsManager = resultsManager else { return }
        guard infiniteScrolling else { return }
        
        if rowNumber + Int(remainingItemsBeforeLoading) >= resultsManager.hits.count {
            resultsManager.loadMore()
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

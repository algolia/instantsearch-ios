//
//  MultiHitsViewModel.swift
//  InstantSearch-iOS
//
//  Created by Guy Daher on 24/11/2017.
//

import Foundation
import InstantSearchCore

/// ViewModel - View: HitsViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
@objcMembers public class MultiHitsViewModel: NSObject, MultiHitsViewModelDelegate, SearchableMultiIndexViewModel {
    
    // MARK: - Properties

    private var _searcherIds: [SearcherId]?

    public var searcherIds: [SearcherId] {
        
        set {
            _searcherIds = newValue
        }
        
        get {
            if let strongSearcherIds = _searcherIds { return strongSearcherIds }
            if let view = view {
                var result: [SearcherId] = []
                for it in 0..<view.indicesArray.count {
                    let id = view.variantsArray.count == view.indicesArray.count
                        ? view.variantsArray[it]
                        : ""
                    let indexName = view.indicesArray[it]
                    result.append(SearcherId(index: indexName, variant: id))
                }

                return result
            } else {
                print("ERROR - ViewModel not associated to any searcherId or View, so it cannot operate")
                return []
            }
        }

    }
    
    public var isClickAnalyticsOn: Bool {
        return view?.isClickAnalyticsOn ?? Constants.Defaults.isClickAnalyticsOn
    }
    
    public var hitsPerSectionArray: [UInt] {
        return view?.hitsPerSectionArray ?? [Constants.Defaults.hitsPerPage]
    }
    
    public var showItemsOnEmptyQuery: Bool {
        return view?.showItemsOnEmptyQuery ?? Constants.Defaults.showItemsOnEmptyQuery
    }
    
    // MARK: - SearchableMultiIndexViewModel
    
    public var resultsManagers: [SearchResultsManageable] = []
    
    public func configure(with resultsManagers: [SearchResultsManageable]) {
        guard !resultsManagers.isEmpty else { return }
        
        // Deal only with the result managers that have been specified in the widget
        searcherIds.forEach { searcherId in
            guard let searcher = resultsManagers.first(where: {
                $0.indexName == searcherId.index && $0.variant == searcherId.variant
            }) else {
                fatalError("Index name not declared when configuring InstantSearch")
            }
            
            self.resultsManagers.append(searcher)
        }
        
        if self.resultsManagers.isEmpty { // not supposed to have this case
            fatalError("No index associated with this widget. Please add at least one index.")
        }
        
        for (index, resultManager) in self.resultsManagers.enumerated() {
            var hitsPerPage: UInt = 0
            if index < hitsPerSectionArray.count {
                hitsPerPage = hitsPerSectionArray[index]
            } else {
                hitsPerPage = hitsPerSectionArray.last ?? Constants.Defaults.hitsPerPage
            }
            
            resultManager.params.hitsPerPage = hitsPerPage
        }
        
        if self.resultsManagers.first!.hits.isEmpty {
            view?.reloadHits()
        }
        
    }
    
    public func configure(withSearchers searchers: [Searcher]) {
        guard !resultsManagers.isEmpty else { return }
        
        // Deal only with the searchers that have been specified in the widget
        searcherIds.forEach { searcherId in
            guard let searcher = searchers.first(where: {
                $0.indexName == searcherId.index && $0.variant == searcherId.variant
            }) else {
                fatalError("Index name not declared when configuring InstantSearch")
            }
            
            self.resultsManagers.append(searcher)
        }
        
        if self.resultsManagers.isEmpty { // not supposed to have this case
            fatalError("No index associated with this widget. Please add at least one index.")
        }
        
        for (index, resultManager) in self.resultsManagers.enumerated() {
            var hitsPerPage: UInt = 0
            if index < hitsPerSectionArray.count {
                hitsPerPage = hitsPerSectionArray[index]
            } else {
                hitsPerPage = hitsPerSectionArray.last ?? Constants.Defaults.hitsPerPage
            }
            
            resultManager.params.hitsPerPage = hitsPerPage
        }
        
        if self.resultsManagers.first!.hits.isEmpty {
            view?.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    public var view: MultiHitsViewDelegate?
    public weak var clickAnalyticsDelegate: ClickAnalyticsDelegate? = Insights.shared

    override init() { }
    
    public init(view: MultiHitsViewDelegate) {
        self.view = view
    }
    
    public func numberOfRows(in section: Int) -> Int {
        guard resultsManagers.count > section else {
            print("Warning - When accessing numberOfRows in MultiHitsViewModel, the section number provided is bigger than the number of provided indices")
            return 0
        }
        let searcher = resultsManagers[section]
        
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
    
    public func numberOfSections() -> Int {
        return resultsManagers.count
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        let resultManager = resultsManagers[indexPath.section]
        
        return resultManager.hits[indexPath.row]
    }
    
    public func queryIDForHits(in section: Int) -> String? {
        guard section < resultsManagers.count else { return .none }
        return resultsManagers[section].results?.queryID
    }
    
    public func captureClickAnalyticsForHit(at indexPath: IndexPath) {

        guard isClickAnalyticsOn else { return }

        let hit = hitForRow(at: indexPath)
        let position = indexPath.row + 1
        let queryID = queryIDForHits(in: indexPath.section)

        if
            let queryID = queryID,
            let indexName = view?.indicesArray[indexPath.section],
            let eventName = view?.hitClickEventName(forSection: indexPath.section),
            let objectID = hit["objectID"] as? String {
            clickAnalyticsDelegate?.clickedAfterSearch(eventName: eventName,
                                                       indexName: indexName,
                                                       objectID: objectID,
                                                       position: position,
                                                       queryID: queryID)
        }

    }

}

// MARK: - ResultingDelegate

extension MultiHitsViewModel: ResultingDelegate {
    
    // MARK: - ResultingDelegate
    
    public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        
        guard results != nil else {
            print(error ?? "")
            return
        }

        view?.reloadHits()
    }
}

extension MultiHitsViewModel: ResettableDelegate {
    func onReset() {
        view?.reloadHits()
    }
}

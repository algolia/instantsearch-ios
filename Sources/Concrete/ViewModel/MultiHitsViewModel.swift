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
        } get {
            if let strongSearcherIds = _searcherIds { return strongSearcherIds}
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
    
    public var hitsPerSectionArray: [UInt] {
        return view?.hitsPerSectionArray ?? [Constants.Defaults.hitsPerPage]
    }
    
    public var showItemsOnEmptyQuery: Bool {
        return view?.showItemsOnEmptyQuery ?? Constants.Defaults.showItemsOnEmptyQuery
    }
    
    // MARK: - SearchableMultiIndexViewModel
    
    public var searchers: [Searcher] = []
    
    public func configure(withSearchers searchers: [Searcher]) {
        guard !searchers.isEmpty else { return }
        
        // Deal only with the searchers that have been specified in the widget
        searcherIds.forEach { (searcherId) in
            guard let searcher = searchers.first(where: {
                $0.indexName == searcherId.index && $0.variant == searcherId.variant
            }) else {
                fatalError("Index name not declared when configuring InstantSearch")
            }
            
            self.searchers.append(searcher)
        }
        
        if self.searchers.isEmpty { // not supposed to have this case
            fatalError("No index associated with this widget. Please add at least one index.")
        }
        
        for (index, searcher) in self.searchers.enumerated() {
            var hitsPerPage: UInt = 0
            if index < hitsPerSectionArray.count {
                hitsPerPage = hitsPerSectionArray[index]
            } else {
                hitsPerPage = hitsPerSectionArray.last ?? Constants.Defaults.hitsPerPage
            }
            
            searcher.params.hitsPerPage = hitsPerPage
        }
        
        if self.searchers.first!.hits.isEmpty {
            view?.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    public var view: MultiHitsViewDelegate?
    
    override init() { }
    
    public init(view: MultiHitsViewDelegate) {
        self.view = view
    }
    
    public func numberOfRows(in section: Int) -> Int {
        guard searchers.count > section else {
            print("Warning - When accessing numberOfRows in MultiHitsViewModel, the section number provided is bigger than the number of provided indices")
            return 0
        }
        let searcher = searchers[section]
        
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
        return searchers.count
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        let searcher = searchers[indexPath.section]
        
        return searcher.hits[indexPath.row]
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

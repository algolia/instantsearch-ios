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
public class MultiHitsViewModel: MultiHitsViewModelDelegate, SearchableMultiIndexViewModel {
    
    // MARK: - Properties
    
    public var searcherIds: [SearcherId] {
        var result: [SearcherId] = []
        for i in 0..<view.indicesArray.count {
            let id = view.variantsArray.count == view.indicesArray.count
                ? view.variantsArray[i]
                : ""
            let indexName = view.indicesArray[i]
            result.append(SearcherId(index: indexName, variant: id))
        }
        
        return result
    }
    
    public var hitsPerSectionArray: [UInt] {
        return view.hitsPerSectionArray
    }
    
    public var showItemsOnEmptyQuery: Bool {
        return view.showItemsOnEmptyQuery
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
            view.reloadHits()
        }
    }
    
    // MARK: - HitsViewModelDelegate
    
    public var view: MultiHitsViewDelegate!
    
    init() { }
    
    public init(view: MultiHitsViewDelegate) {
        self.view = view
    }
    
    public func numberOfRows(in section: Int) -> Int {
        // guard let searchers.count
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
        
        view.reloadHits()
    }
}

extension MultiHitsViewModel: ResettableDelegate {
    func onReset() {
        view.reloadHits()
    }
}

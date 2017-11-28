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
internal class MultiHitsViewModel: MultiHitsViewModelDelegate, SearchableMultiIndexViewModel {
    
    // MARK: - Properties
    
    var indexNamesArray: [String] {
        return view.indexNamesArray
    }
    
    var indexIdsArray: [String] {
        return view.indexIdsArray
    }
    
    var hitsPerSection: UInt {
        return view.hitsPerSection
    }

    var showItemsOnEmptyQuery: Bool {
        return view.showItemsOnEmptyQuery
    }

    // MARK: - SearchableMultiIndexViewModel
    
    var searchers: [Searcher] = []
    
    func configure(withSearchers searchers: [Searcher]) {
        guard !searchers.isEmpty else { return }
        
        // Deal only with the searchers that have been specified in the widget
        for i in 0..<indexIdsArray.count {
            guard let searcher = searchers.first(where: { $0.indexName == indexNamesArray[i] && $0.indexId == indexIdsArray[i] }) else {
                fatalError("Index name not declared when configuring InstantSearch")
            }
            self.searchers.append(searcher)
        }
        
        for searcher in self.searchers {
            searcher.params.hitsPerPage = hitsPerSection
        }
        
        // TODO: Throw better error is no searcher is associated with this view.
        if !self.searchers.isEmpty && self.searchers.first!.hits.isEmpty {
            view.reloadHits()
        }
    }

    // MARK: - HitsViewModelDelegate

    var view: MultiHitsViewDelegate!
    
    func numberOfRows(in section: Int) -> Int {
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
    
    func numberOfSections() -> Int {
        return searchers.count
    }

    func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        let searcher = searchers[indexPath.section]

        return searcher.hits[indexPath.row]
    }
}

// MARK: - ResultingDelegate

extension MultiHitsViewModel: ResultingDelegate {

    // MARK: - ResultingDelegate

    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {

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


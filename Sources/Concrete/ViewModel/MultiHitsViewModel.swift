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
        self.searchers = searchers
        for searcher in searchers {
            searcher.params.hitsPerPage = hitsPerSection
        }
        
        // we're sure it's not empty since we check at the beginning
        if searchers.first!.hits.isEmpty {
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

    func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        let searcher = searchers[indexPath.section]

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

extension MultiHitsViewModel: ResultingDelegate {

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

extension MultiHitsViewModel: ResettableDelegate {
    func onReset() {
        view.reloadHits()
    }
}


//
//  StatsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 10/04/2017.
//
//

import Foundation
import InstantSearchCore

/// ViewModel - View: StatsViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
@objcMembers public class StatsViewModel: NSObject, StatsViewModelDelegate, SearchableIndexViewModel {
    
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
    
    public var resultTemplate: String {
        return view?.resultTemplate ?? Constants.Defaults.resultTemplate
    }
    
    public var errorText: String {
        return view?.errorText ?? Constants.Defaults.errorText
    }
    
    public var clearText: String {
        return view?.clearText ?? Constants.Defaults.clearText
    }
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        // Initial value of label in case a search was made.
        // If a search wasn't made yet and it is still ongoing, then the label will get initialized in the onResult method
        if let results = searcher.results {
            let text = applyTemplate(resultTemplate: resultTemplate, results: results)
            view?.set(text: text)
        } else {
            let text = clearText
            view?.set(text: text)
        }
    }
    
    // MARK: - StatsViewModelDelegate
    
    public weak var view: StatsViewDelegate?
    
    override init() { }
    
    public init(view: StatsViewDelegate) {
        self.view = view
    }
}

// MARK: - ResettableDelegate

extension StatsViewModel: ResettableDelegate {
    func onReset() {
        view?.set(text: clearText)
    }
}

// MARK: - ResultingDelegate

extension StatsViewModel: ResultingDelegate {
    public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let results = results {
            let text = applyTemplate(resultTemplate: resultTemplate, results: results)
            view?.set(text: text)
        }
        
        if error != nil {
            let text = errorText
            view?.set(text: text)
            print(error!)
        }
    }
}

// MARK: - Presentational helper methods

extension StatsViewModel {
    func applyTemplate(resultTemplate: String, results: SearchResults) -> String {
        return resultTemplate.replacingOccurrences(of: "{hitsPerPage}", with: "\(results.hitsPerPage)")
            .replacingOccurrences(of: "{processingTimeMS}", with: "\(results.processingTimeMS)")
            .replacingOccurrences(of: "{nbHits}", with: "\(results.nbHits)")
            .replacingOccurrences(of: "{nbPages}", with: "\(results.nbPages)")
            .replacingOccurrences(of: "{page}", with: "\(results.page)")
            .replacingOccurrences(of: "{query}", with: "\(String(describing: results.query))")
    }
}

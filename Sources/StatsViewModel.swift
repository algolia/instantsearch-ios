//
//  StatsViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 10/04/2017.
//
//

import UIKit
import InstantSearchCore

@IBDesignable
public class StatsViewModel: ResultingDelegate, SearchableViewModel, ResettableDelegate, StatsViewModelDelegate {
    
    weak public var view: StatsViewDelegate!
    
    public var searcher: Searcher! {
        didSet {
            if view.resultTemplate.isEmpty {
                view.resultTemplate = defaultResultTemplate
            }
            
            // Initial value of label in case a search was made.
            // If a search wasn't made yet and it is still ongoing, then the label will get initialized in the onResult method
            if let results = searcher.results {
                let text = applyTemplate(resultTemplate: view.resultTemplate, results: results)
                view.set(text: text)
            } else {
                let text = view.clearText
                view.set(text: text)
            }
        }
    }
    
    private let defaultResultTemplate = "{nbHits} results found in {processingTimeMS} ms"
    
    public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let results = results {
            let text = applyTemplate(resultTemplate: view.resultTemplate, results: results)
            view.set(text: text)
        }
        
        if error != nil {
            let text = "Error in fetching results"
            view.set(text: text)
        }
    }
    
    // MARK: - Helper methods
    
    private func applyTemplate(resultTemplate: String, results: SearchResults) -> String {
        return resultTemplate.replacingOccurrences(of: "{hitsPerPage}", with: "\(results.hitsPerPage)")
            .replacingOccurrences(of: "{processingTimeMS}", with: "\(results.processingTimeMS)")
            .replacingOccurrences(of: "{nbHits}", with: "\(results.nbHits)")
            .replacingOccurrences(of: "{nbPages}", with: "\(results.nbPages)")
            .replacingOccurrences(of: "{page}", with: "\(results.page)")
            .replacingOccurrences(of: "{query}", with: "\(String(describing: results.query))")
    }
    
    public func onReset() {
        view.set(text: view.clearText)
    }
}



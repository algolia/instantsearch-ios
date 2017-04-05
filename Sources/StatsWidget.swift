//
//  StatsWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 09/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

@IBDesignable
@objc public class StatsWidget: UILabel, AlgoliaOutputWidget {
    public var searcher: Searcher! {
        didSet {
            if self.resultTemplate == nil {
                self.resultTemplate = defaultResultTemplate
            }
            
            // Initial value of label in case a search was made.
            // If a search wasn't made yet and it is still ongoing, then the label will get initialized in the onResult method
            if let results = searcher.results {
                text = applyTemplate(resultTemplate: resultTemplate, results: results)
            }
        }
    }
    
    @IBInspectable public var resultTemplate: String! // TODO: Unsafe, fix that
    public var errorTemplate: String?
    
    private let defaultResultTemplate = "{nbHits} results found in {processingTimeMS} ms"
    
    public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let results = results {
            text = applyTemplate(resultTemplate: resultTemplate, results: results)
        }
        
        if error != nil {
            text = "Error in fetching results"
        }
    }
    
    // MARK: - Helper methods
    
    private func applyTemplate(resultTemplate: String, results: SearchResults) -> String{
        return resultTemplate.replacingOccurrences(of: "{hitsPerPage}", with: "\(results.hitsPerPage)")
            .replacingOccurrences(of: "{processingTimeMS}", with: "\(results.processingTimeMS)")
            .replacingOccurrences(of: "{nbHits}", with: "\(results.nbHits)")
            .replacingOccurrences(of: "{nbPages}", with: "\(results.nbPages)")
            .replacingOccurrences(of: "{page}", with: "\(results.page)")
            .replacingOccurrences(of: "{query}", with: "\(String(describing: results.query))")
    }
}

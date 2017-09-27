//
//  activityIndicatorView.swift
//  ecommerce
//
//  Created by Guy Daher on 13/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

/// Widget that spins when an Algolia request is ongoing. Built on top of `UIActivityIndicatorView`.
@objc public class ActivityIndicatorWidget: UIActivityIndicatorView,
    SearchableViewModel, SearchProgressDelegate, AlgoliaWidget {

    var searchProgressController: SearchProgressController!
    public var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        searchProgressController = SearchProgressController(searcher: searcher)
        
        searchProgressController.graceDelay = 0.01
        searchProgressController.delegate = self
    }
    
    // MARK: - SearchProgressDelegate methods
    
    public func searchDidStart(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        startAnimating()
    }
    
    public func searchDidStop(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        stopAnimating()
        
    }

}

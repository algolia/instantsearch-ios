//
//  activityIndicatorView.swift
//  ecommerce
//
//  Created by Guy Daher on 13/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

class ActivityIndicatorView: UIActivityIndicatorView, AlgoliaWidget, SearchProgressDelegate {

    var searchProgressController: SearchProgressController!
    
    // MARK: - AlgoliaWidget methods
    
    func initWith(searcher: Searcher) {
        searchProgressController = SearchProgressController(searcher: searcher)
        
//        if searcher.hits == nil {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            startAnimating()
//        }
        
        searchProgressController.graceDelay = 0.01
        searchProgressController.delegate = self
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        
    }
    
    // MARK: - SearchProgressDelegate methods
    
    func searchDidStart(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        startAnimating()
    }
    
    func searchDidStop(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        stopAnimating()
        
    }

}

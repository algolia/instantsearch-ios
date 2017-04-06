//
//  activityIndicatorView.swift
//  ecommerce
//
//  Created by Guy Daher on 13/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

@objc public class ActivityIndicatorView: UIActivityIndicatorView, SearcherInterface, SearchProgressDelegate {

    var searchProgressController: SearchProgressController!
    public var searcher: Searcher!
    
    // MARK: - SearcherInterface methods
    
    public func initWith(searcher: Searcher) {
        searchProgressController = SearchProgressController(searcher: searcher)
        
//        if searcher.hits == nil {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            startAnimating()
//        }
        
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

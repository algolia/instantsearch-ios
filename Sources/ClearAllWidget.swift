//
//  ClearAllWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 17/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

@objc public class ClearAllWidget: UIButton, AlgoliaWidget {

    public var searcher: Searcher! {
        didSet {
            addTarget(self, action: #selector(self.clearFilter), for: .touchUpInside)
        }
    }
    
    public func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        
    }
    
    internal func clearFilter() {
        searcher.params.clearRefinements()
        NotificationCenter.default.post(name: clearAllFiltersNotification, object: nil)
        searcher.search()
    }

}

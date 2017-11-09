//
//  ClearAllWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 17/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

let clearAllFiltersNotification = Notification.Name(rawValue: "clearAllFiltersNotification")

@objc private class ClearAllWidget: UIButton, SearchableViewModel, AlgoliaWidget {

    @IBInspectable public var indexName: String = Constants.Defaults.indexName
    @IBInspectable public var indexId: String = Constants.Defaults.indexId
    
    public var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searcher = searcher
        addTarget(self, action: #selector(self.clearFilter), for: .touchUpInside)
    }
    
    @objc internal func clearFilter() {
        searcher.reset()
        NotificationCenter.default.post(name: clearAllFiltersNotification, object: nil)
    }

}

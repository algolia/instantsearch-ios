//
//  AlgoliaWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc protocol AlgoliaWidget: class {
    @objc func initWith(searcher: Searcher)
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any])
    @objc optional func onReset()
}

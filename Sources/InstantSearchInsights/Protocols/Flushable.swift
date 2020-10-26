//
//  Flushable.swift
//  Insights
//
//  Created by Vladislav Fitc on 16/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol Flushable {
    var flushDelay: TimeInterval { get set }
    func flush()
}

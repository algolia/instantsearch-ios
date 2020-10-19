//
//  Date+Milliseconds.swift
//  Insights
//
//  Created by Vladislav Fitc on 30/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public extension Date {

    var millisecondsSince1970: Int64 {
        return timeIntervalSince1970.milliseconds
    }

    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }

}

public extension TimeInterval {

    var milliseconds: Int64 {
        return Int64((self * 1000.0).rounded())
    }

}

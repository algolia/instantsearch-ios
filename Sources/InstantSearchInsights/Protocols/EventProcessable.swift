//
//  EventProcessable.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol EventProcessable: class {
    
    var isActive: Bool { get set }
    func process(_ event: Event)
    
}

//
//  TestEventProcessor.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchInsights

class TestEventProcessor: EventProcessable {
    
    var didProcess: (Event) -> Void = { _ in }
    
    var isActive: Bool = true
    
    func process(_ event: Event) {
        guard isActive else { return }
        didProcess(event)
    }
    
}

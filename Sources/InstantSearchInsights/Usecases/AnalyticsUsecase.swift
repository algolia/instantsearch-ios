//
//  AnalyticsUsecase.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol AnalyticsUsecase {
    
    var eventProcessor: EventProcessable { get }
    var logger: Logger { get }
    var userToken: String? { get }
    
}

extension AnalyticsUsecase {
    
    /// Provides an appropriate user token
    /// There are three user tokens levels
    /// 1) Global automatically created app user token
    /// 2) Per-app user token
    /// 3) Per-event user token
    /// The propagation starts from the deepest level and switches to the previous one in case of nil value on the current level.
    
    func effectiveUserToken(withEventUserToken eventUserToken: String?) -> String {
        return eventUserToken ?? self.userToken ?? Insights.userToken
    }
    
}

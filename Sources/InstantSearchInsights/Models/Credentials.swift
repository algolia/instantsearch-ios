//
//  Credentials.swift
//  Insights
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class Credentials: NSObject {
    
    let appId: String
    let apiKey: String
    
    init(appId: String, apiKey: String) {
        self.appId = appId
        self.apiKey = apiKey
        super.init()
    }
    
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(appId.hash)
        hasher.combine(apiKey.hash)
        return hasher.finalize()
    }
    
}

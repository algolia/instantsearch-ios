//
//  APIEndpoint.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

enum Environment {
    case prod
    case dev
}

let environment: Environment = {
    let env: Environment
    #if DEV
    env = Environment.dev
    #else
    env = Environment.prod
    #endif
    return env
}()

protocol APIEndpoint {
    /// server baseURL
    static func baseURL(forRegion region: Region?) -> URL
    /// for api calls
    static func baseAPIURL(forRegion region: Region?) -> URL
    static func url(path: String, region: Region?) -> URL
}

extension APIEndpoint {
    static func url(path: String, region: Region?) -> URL {
        return URL(string: path, relativeTo: baseAPIURL(forRegion: region))!
    }
}

struct API {
}

extension API: APIEndpoint {
    
    static func baseURL(forRegion region: Region?) -> URL {
        switch environment {
        case .prod:
            let suffix = effectiveRegionSuffix(forCustomRegion: region)
            return URL(string: "https://insights\(suffix).algolia.io")!
            
        case .dev:
            return URL(string: "http://localhost:8080")!
        }
    }
    
    static func baseAPIURL(forRegion region: Region?) -> URL {
        return URL(string: "/1/events/", relativeTo: baseURL(forRegion: region))!
    }
    
    private static func effectiveRegionSuffix(forCustomRegion customRegion: Region?) -> String {
        return customRegion?.urlSuffix ?? Insights.region?.urlSuffix ?? ""
    }
    
}

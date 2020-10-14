//
//  HttpMethod.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get([URLQueryItem])
    case post([URLQueryItem], Body)
    case put([URLQueryItem], Body)
    case delete([URLQueryItem])
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
    
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get(let qs): return .get(qs)
        case .post(let params, let body):
            return .post(params, f(body))
        case .put(let params, let body):
            return .put(params, f(body))
        case .delete(let params): return .delete(params)
        }
    }
}

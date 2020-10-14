//
//  NSMutableURLRequest+Resource.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

extension URLRequest {
    init<A, E>(resource: Resource<A, E>) {
        
        var requestParams: [URLQueryItem]?
        var requestBody: Data?
        
        switch resource.method {
        case .get(let params):
            requestParams = params
        case .post(let params, let data):
            requestParams = params
            requestBody = data
        case .put(let params, let data):
            requestParams = params
            requestBody = data
        case .delete(let params):
            requestParams = params
        }
        var requestComponents = URLComponents()
        requestComponents.host =  resource.url.host
        requestComponents.scheme = resource.url.scheme
        requestComponents.path = resource.url.path
        requestComponents.port = resource.url.port
        requestComponents.queryItems = requestParams
        
        self.init(url: (requestComponents.url)!)
        httpMethod = resource.method.method
        httpBody = requestBody
        setValue(resource.contentType, forHTTPHeaderField: "Content-Type")
        for (key, value) in resource.aditionalHeaders {
            setValue(value, forHTTPHeaderField: key)
        }
    }
}

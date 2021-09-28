//
//  MultiRequest.swift
//  
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation

/// A request composed of multiple sub-requests
public protocol MultiRequest {
  associatedtype SubRequest
  var subRequests: [SubRequest] { get set }
}

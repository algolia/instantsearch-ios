//
//  EventsService.swift
//  
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation

public protocol EventsService {

  associatedtype Event

  func sendEvents(_ events: [Event], completion: @escaping (Result<Void, Error>) -> Void)

  static func isRetryable(_ error: Error) -> Bool

}

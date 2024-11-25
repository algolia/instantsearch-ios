//
//  AnyWaitable.swift
//  
//
//  Created by Vladislav Fitc on 29/04/2020.
//

import Foundation

public protocol AnyWaitable {

  func wait(timeout: TimeInterval?, requestOptions: RequestOptions?) throws
  func wait(timeout: TimeInterval?, requestOptions: RequestOptions?, completion: @escaping (Result<Empty, Swift.Error>) -> Void)

}

extension Array where Element == AnyWaitable {

  func waitAll(timeout: TimeInterval? = nil, requestOptions: RequestOptions? = nil) throws {
    for element in self {
      try element.wait(timeout: timeout, requestOptions: requestOptions)
    }
  }

}

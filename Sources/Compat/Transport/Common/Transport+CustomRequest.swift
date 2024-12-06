//
//  Transport+CustomRequest.swift
//  
//
//  Created by Vladislav Fitc on 18/04/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Transport {

  // MARK: - Custom request

  /**
   Perform custom request
   
   - Parameter callType: Type of HTTP call determining timeout duration.
   - Parameter request: URL requests to perform.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func customRequest<T: Decodable>(callType: CallType,
                                                      request: URLRequest,
                                                      requestOptions: RequestOptions? = nil,
                                                      completion: @escaping ResultCallback<T>) -> Operation {
    guard let command = try? Command.Custom(callType: callType, urlRequest: request, requestOptions: requestOptions) else {
      return Operation()
    }
    return execute(command, completion: completion)
  }

  /**
   Perform custom request
   
   - Parameter callType: Type of HTTP call determining timeout duration.
   - Parameter request: URL requests to perform.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Specified generic object
   */

  @discardableResult func customRequest<T: Decodable>(callType: CallType,
                                                      request: URLRequest,
                                                      requestOptions: RequestOptions? = nil) throws -> T {
    let command = try Command.Custom(callType: callType, urlRequest: request, requestOptions: requestOptions)
    return try execute(command)
  }

}

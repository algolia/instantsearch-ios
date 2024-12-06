//
//  Command+Custom.swift
//  
//
//  Created by Vladislav Fitc on 11/02/2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Command {

  struct Custom: AlgoliaCommand {

    let method: HTTPMethod
    let callType: CallType
    let path: URL
    let body: Data?
    let requestOptions: RequestOptions?

    init(method: HTTPMethod,
         callType: CallType,
         path: URL,
         body: Data?,
         requestOptions: RequestOptions?) {
      self.method = method
      self.callType = callType
      self.path = path
      self.body = body
      self.requestOptions = requestOptions
    }

    init(callType: CallType,
         urlRequest: URLRequest,
         requestOptions: RequestOptions?) throws {
      self.callType = callType
      self.method = urlRequest.httpMethod.flatMap(HTTPMethod.init(rawValue:)) ?? .get
      guard let url = urlRequest.url else {
        throw URLRequest.FormatError.missingURL
      }
      guard let pathURL = URL(string: url.path) else {
        throw URLRequest.FormatError.invalidPath(url.path)
      }
      self.path = pathURL
      self.body = urlRequest.httpBody
      self.requestOptions = requestOptions
    }

  }

}

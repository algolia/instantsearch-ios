//
//  URLRequest+APIKey.swift
//
//
//  Created by Vladislav Fitc on 20/07/2022.
//

import Core
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

  static let maxHeaderAPIKeyLength = 500

  internal mutating func setAPIKey(_ apiKey: APIKey?) throws {

    guard let apiKeyValue = apiKey?.rawValue, apiKeyValue.count > URLRequest.maxHeaderAPIKeyLength else {
      self[header: .apiKey] = apiKey?.rawValue
      return
    }

    // FIXME: Logger is part of Core and its method are internal
    // Logger.warning("The API length is > \(URLRequest.maxHeaderAPIKeyLength). Attempt to insert it into request body.")

    guard let body = httpBody else {
      throw APIKeyBodyError.missingHTTPBody
    }

    let decodingResult = Result { try JSONDecoder().decode(JSON.self, from: body) }
    guard case .success(let bodyJSON) = decodingResult else {
      if case .failure(let error) = decodingResult {
        throw APIKeyBodyError.bodyDecodingJSONError(error)
      }
      return
    }

    guard case .dictionary(var jsonDictionary) = bodyJSON else {
      throw APIKeyBodyError.bodyNonKeyValueJSON
    }

    jsonDictionary["apiKey"] = .string(apiKeyValue)

    let encodingResult = Result { try JSONEncoder().encode(jsonDictionary) }
    guard case .success(let updatedBody) = encodingResult else {
      if case .failure(let error) = encodingResult {
        throw APIKeyBodyError.bodyEncodingJSONError(error)
      }
      return
    }

    httpBody = updatedBody
  }

}

public extension URLRequest {

  enum APIKeyBodyError: Error, CustomStringConvertible {
    case missingHTTPBody
    case bodyDecodingJSONError(Error)
    case bodyNonKeyValueJSON
    case bodyEncodingJSONError(Error)

    public var description: String {
      switch self {
      case .missingHTTPBody:
        return "Request doesn't contain HTTP body"
      case .bodyDecodingJSONError(let error):
        return "HTTP body JSON decoding error: \(error)"
      case .bodyEncodingJSONError(let error):
        return "HTTP body JSON encoding error: \(error)"
      case .bodyNonKeyValueJSON:
        return "HTTP body JSON is not key-value type"
      }
    }
  }

}

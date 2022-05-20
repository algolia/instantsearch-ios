//
//  JSONDecoder.swift
//  
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import Foundation

enum ResourceDecodingError: Error {
  case missingResource(resource: String?, extension: String?)
  case dataReadError(Error)
  case decodingError(Error)
}

extension JSONDecoder {
  
  func decode<T: Decodable>(fromResource resource: String?, withExtension extension: String?) throws -> T {
    guard let url = Bundle.module.url(forResource: resource, withExtension: `extension`) else {
      throw ResourceDecodingError.missingResource(resource: resource, extension: `extension`)
    }
    let data: Data
    do {
      data = try Data(contentsOf: url)
    } catch let error {
      throw ResourceDecodingError.dataReadError(error)
    }
    let output: T
    do {
      output = try decode(T.self, from: data)
    } catch let error {
      throw ResourceDecodingError.decodingError(error)
    }
    return output
  }
  
}

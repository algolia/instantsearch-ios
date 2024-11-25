//
//  AlgoliaCommand.swift
//  
//
//  Created by Vladislav Fitc on 10.03.2020.
//

import Foundation

protocol AlgoliaCommand {

  var method: HTTPMethod { get }
  var callType: CallType { get }
  var path: URL { get }
  var body: Data? { get }
  var requestOptions: RequestOptions? { get }

}

extension AlgoliaCommand {

  var body: Data? {
    return nil
  }

}

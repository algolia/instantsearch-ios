//
//  Command.swift
//  
//
//  Created by Vladislav Fitc on 10.03.2020.
//

import Foundation

enum Command {
}

extension Command {
  struct Template: AlgoliaCommand {
    var method: HTTPMethod = .get
    let callType: CallType = .read
    let path = URL.indexesV1
    let body: Data?
    let requestOptions: RequestOptions? = nil
  }
}

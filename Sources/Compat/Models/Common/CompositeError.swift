//
//  CompositeError.swift
//  
//
//  Created by Vladislav Fitc on 21/07/2022.
//

import Foundation

public struct CompositeError: Error {

  public let errors: [Error]

  public init(errors: [Error]) {
    self.errors = errors
  }

  public static func with(_ errors: Error...) -> Self {
    CompositeError(errors: errors)
  }

}

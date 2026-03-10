//
//  AlgoliaService.swift
//
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import AlgoliaCore
import Foundation

public protocol AlgoliaRequest {
  var requestOptions: RequestOptions? { get set }
}

//
//  CompositeResult.swift
//  
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation

/// A result composed of multiple sub-results
public protocol CompositeResult {
  associatedtype SubResult
  var subResults: [SubResult] { get }
}

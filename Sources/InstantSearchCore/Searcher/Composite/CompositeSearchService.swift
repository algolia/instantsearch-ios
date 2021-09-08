//
//  CompositeSearchService.swift
//  
//
//  Created by Vladislav Fitc on 08/09/2021.
//

import Foundation

public protocol CompositeSearchService: SearchService where Request == [RequestUnit], Result == [ResultUnit] {
  
  associatedtype RequestUnit
  associatedtype ResultUnit
  
}

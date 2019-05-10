//
//  HitsSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 10/05/2019.
//

import Foundation

public protocol HitsSource: class {
  
  associatedtype Record: Codable
  
  func numberOfHits() -> Int
  func hit(atIndex index: Int) -> Record?
  
}

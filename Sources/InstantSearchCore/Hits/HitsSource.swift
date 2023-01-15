//
//  HitsSource.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol HitsSource: AnyObject {

  associatedtype Record: Codable

  func numberOfHits() -> Int
  func hit(atIndex index: Int) -> Record?

}

extension HitsInteractor: HitsSource {}

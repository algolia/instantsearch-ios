//
//  HitsWidget.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/04/2019.
//

import Foundation
import InstantSearchCore

public protocol HitsWidget: class {
  
  associatedtype DataSource: HitsSource
  
  var hitsSource: DataSource? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

extension HitsViewModel: HitsSource {}

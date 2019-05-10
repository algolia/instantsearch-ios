//
//  MultiHitsWidget.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/04/2019.
//

import Foundation

public protocol MultiHitsWidget: class {
  
  var hitsSource: MultiHitsSource? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

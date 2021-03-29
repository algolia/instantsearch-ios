//
//  StatsObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class StatsObservableController: ObservableObject, StatsTextController {
  
  @Published public var stats: String
  
  public func setItem(_ item: String?) {
    stats = item ?? ""
    objectWillChange.send()
  }
  
  public init(stats: String = "") {
    self.stats = stats
  }
  
}

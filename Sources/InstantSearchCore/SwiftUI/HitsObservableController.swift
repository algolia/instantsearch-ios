//
//  HitsObservableController.swift
//  
//
//  Created by Vladislav Fitc on 26/03/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class HitsObservableController<Item: Codable>: ObservableObject, HitsController {
    
  public var hitsSource: HitsInteractor<Item>?
  
  @Published public var hits: [Item?] = []
  @Published public var scrollID: UUID = .init()
  
  public func scrollToTop() {
    scrollID = .init()
  }
  
  public func reload() {
    guard let paginator = self.hitsSource?.paginator, !paginator.isInvalidated,
          let pageMap = paginator.pageMap else {
      hits.removeAll()
      return
    }
    self.hits = pageMap.map { $0 }
  }
  
  public func notify(index: Int) {
    hitsSource?.notifyForInfiniteScrolling(rowNumber: index)
  }
  
  public init() {}
    
}

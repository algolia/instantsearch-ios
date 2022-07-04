//
//  PageLoadable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol PageLoadable: AnyObject {

  func loadPage(atIndex pageIndex: Int)

}

extension HitsSearcher: PageLoadable {

  public func loadPage(atIndex pageIndex: Int) {
    request.query.page = pageIndex
    search()
  }

}

extension FacetSearcher: PageLoadable {

  public func loadPage(atIndex pageIndex: Int) {
    request.context.page = pageIndex
    search()
  }

}

@available(*, deprecated, message: "Places feature is deprecated")
extension PlacesSearcher: PageLoadable {

  public func loadPage(atIndex pageIndex: Int) {
    search()
  }

}

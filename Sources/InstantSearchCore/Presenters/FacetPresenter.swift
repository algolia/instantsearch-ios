//
//  FacetPresenter.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias FacetPresenter = (Facet) -> String

public extension DefaultPresenter {

  enum Facet {

    public static let present: FacetPresenter = { facet in
      return "\(facet.value) \(facet.count)"
    }

  }
}

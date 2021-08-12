//
//  MultiIndexHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public protocol MultiIndexHitsController: AnyObject, Reloadable {

  var hitsSource: MultiIndexHitsSource? { get set }

  func scrollToTop()

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
extension MultiIndexHitsInteractor: MultiIndexHitsSource {}

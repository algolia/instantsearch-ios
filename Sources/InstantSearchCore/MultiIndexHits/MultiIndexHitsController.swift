//
//  MultiIndexHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol MultiIndexHitsController: class, Reloadable {

  var hitsSource: MultiIndexHitsSource? { get set }

  func scrollToTop()

}

extension MultiIndexHitsInteractor: MultiIndexHitsSource {}

//
//  LoadingInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 10/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Business logic for a loading state
public class LoadingInteractor: ItemInteractor<Bool> {
  public init() {
    super.init(item: false)
    Telemetry.shared.trace(type: .loading)
  }
}

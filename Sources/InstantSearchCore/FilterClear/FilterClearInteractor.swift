//
//  FilterClearInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterClearInteractor: EventInteractor {
  public let onTriggered: Observer<Void>

  public init() {
    onTriggered = .init()
  }
}

//
//  HitsInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct HitsInteractorFilterStateConnection<Interactor: AnyHitsInteractor>: Connection {

  public let interactor: Interactor
  public let filterState: FilterState

  public func connect() {
    filterState.onChange.subscribePast(with: interactor) { interactor, _ in
      interactor.notifyQueryChanged()
    }
  }

  public func disconnect() {
    filterState.onChange.cancelSubscription(for: interactor)
  }

}

public extension AnyHitsInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState) -> Connection {
    let connection = HitsInteractorFilterStateConnection(interactor: self, filterState: filterState)
    connection.connect()
    return connection
  }

}

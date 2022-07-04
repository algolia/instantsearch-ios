//
//  HitsInteractor+PlacesSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Places feature is deprecated")
public extension HitsInteractor where Record == Hit<Place> {

  struct PlacesSearcherConnection: Connection {

    public let interactor: HitsInteractor<Record>
    public let searcher: PlacesSearcher

    public func connect() {

      interactor.pageLoader = searcher

      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in
        interactor.update(searchResults)
      }

      searcher.onError.subscribe(with: interactor) { _, _ in
        // TODO: when pagination added, notify pending query in infinite scrolling controller
      }

      searcher.onQueryChanged.subscribe(with: interactor) { (interactor, _) in
        interactor.notifyQueryChanged()
      }

    }

    public func disconnect() {
      if interactor.pageLoader === searcher {
        interactor.pageLoader = nil
      }
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
      searcher.onQueryChanged.cancelSubscription(for: interactor)
    }

  }

}

public extension HitsInteractor where Record == Hit<Place> {

  @available(*, deprecated, message: "Places feature is deprecated")
  @discardableResult func connectPlacesSearcher(_ searcher: PlacesSearcher) -> PlacesSearcherConnection {
    let connection = PlacesSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}

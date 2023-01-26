//
//  PlacesSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import AlgoliaSearchClient
import Foundation

@available(*, deprecated, message: "Places feature is deprecated")
public final class PlacesSearcher: AbstractSearcher<AlgoliaPlacesSearchService> {
  public var placesQuery: PlacesQuery {
    get {
      request.query
    }

    set {
      request.query = newValue
    }
  }

  convenience init(client: PlacesClient, query: PlacesQuery = .init()) {
    let initialRequest = Request(query: query, language: .english)
    self.init(service: .init(client: client), initialRequest: initialRequest)
  }

  convenience init(appID: ApplicationID,
                   apiKey: APIKey,
                   query: PlacesQuery = .init()) {
    let client = PlacesClient(appID: appID, apiKey: apiKey)
    self.init(client: client, query: query)
  }
}

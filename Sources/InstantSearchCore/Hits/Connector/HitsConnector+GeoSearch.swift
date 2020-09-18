//
//  HitsConnector+GeoSearch.swift
//  
//
//  Created by Vladislav Fitc on 12/09/2020.
//

import Foundation

extension Hit: Geolocated {}
public typealias PlaceHit = Hit<Place>

public extension HitsConnector where Hit == PlaceHit {

  /**
   Convenient initializer for Places search
   - Parameters:
     - searcher: Places Searcher that handles your searches
     - interactor: External hits interactor
  */
  convenience init(searcher: PlacesSearcher,
                   interactor: HitsInteractor<Hit>) {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
  }
  
  /**
   Convenient initializer for Places search
   - Parameters:
     - placesAppID: Places Application ID
     - apiKey: Places API Key
     - infiniteScrolling: Infinite scrolling toggle
     - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
  */
  convenience init(placesAppID: ApplicationID,
                   apiKey: APIKey,
                   infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                   showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery) {
    let searcher = PlacesSearcher(appID: placesAppID, apiKey: apiKey)
    let interactor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling, showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
  }

}

public extension HitsConnector where Hit == PlaceHit {

  /**
   Convenient initializer for Places search
   - Parameters:
     - searcher: Places Searcher that handles your searches
     - interactor: External hits interactor
     - controller: Controller interfacing with a concrete hits view
  */
  convenience init<Controller: GeoHitsController>(searcher: PlacesSearcher,
                                                  interactor: HitsInteractor<Hit>,
                                                  controller: Controller) where Controller.DataSource == HitsInteractor<PlaceHit>  {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
    connectController(controller)
  }
  
  /**
   Convenient initializer for Places search
   - Parameters:
     - placesAppID: Places Application ID
     - apiKey: Places API Key
     - infiniteScrolling: Infinite scrolling toggle
     - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
     - controller: Controller interfacing with a concrete hits view
  */
  convenience init<Controller: GeoHitsController>(placesAppID: ApplicationID,
                                                  apiKey: APIKey,
                                                  infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                                                  showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery,
                                                  controller: Controller) where Controller.DataSource == HitsInteractor<PlaceHit> {
    let searcher = PlacesSearcher(appID: placesAppID, apiKey: apiKey)
    let interactor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling, showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
    connectController(controller)
  }
  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete hits view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: GeoHitsController>(_ controller: Controller) -> HitsInteractor<PlaceHit>.GeoHitsControllerConnection<Controller> where Controller.DataSource == HitsInteractor<PlaceHit> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}

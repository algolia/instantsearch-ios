//
//  MultiHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 22/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
public typealias MultiHitsWidget = InstantSearchCore.MultiIndexHitsController

public class MultiHitsController<HitsWidget: MultiHitsWidget>: NSObject {
  
  public let searcher: MultiIndexSearcher
  public let interactor: MultiIndexHitsInteractor
  public weak var widget: HitsWidget?
  public let onError: Observer<Error>

  public init(client: Client, widget: HitsWidget, interactor: MultiIndexHitsInteractor) {
    self.searcher = MultiIndexSearcher(client: client, indexQueryStates: [])
    self.interactor = interactor
    self.widget = widget
    self.onError = Observer<Error>()
    super.init()
    
    interactor.connectSearcher(searcher)
    
    self.widget?.hitsSource = interactor
    
  }
  
  public func searchWithQueryText(_ queryText: String) {
    searcher.query = queryText
    searcher.search()
  }
  
}

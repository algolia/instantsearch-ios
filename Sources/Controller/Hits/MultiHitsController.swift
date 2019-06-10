//
//  MultiHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 22/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
public typealias MultiHitsWidget = InstantSearchCore.MultiHitsController

public class MultiHitsController<HitsWidget: MultiHitsWidget>: NSObject {
  
  public let searcher: MultiIndexSearcher
  public let viewModel: MultiHitsViewModel
  public weak var widget: HitsWidget?
  public let onError: Observer<Error>

  public init(client: Client, widget: HitsWidget, viewModel: MultiHitsViewModel) {
    self.searcher = MultiIndexSearcher(client: client, indexSearchDatas: [])
    self.viewModel = viewModel
    self.widget = widget
    self.onError = Observer<Error>()
    super.init()
    
    viewModel.connectSearcher(searcher)
    
    self.widget?.hitsSource = viewModel
    
  }
  
  public func searchWithQueryText(_ queryText: String) {
    searcher.query = queryText
    searcher.search()
  }
  
}

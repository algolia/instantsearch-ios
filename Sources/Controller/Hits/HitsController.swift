//
//  HitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

public typealias HitViewConfigurator<HitsView, SingleHitView, Hit> = (HitsView, Hit, IndexPath) -> SingleHitView
public typealias HitClickHandler<HitsView, Hit> = (HitsView, Hit, IndexPath) -> Void

public typealias HitsWidget = InstantSearchCore.HitsController

public class HitsController<Record: Codable>: NSObject {

  public let searcher: SingleIndexSearcher
  public let viewModel: HitsViewModel<Record>
  public let onError: Observer<Error>

  public init<Widget: HitsWidget>(searcher: SingleIndexSearcher, viewModel: HitsViewModel<Record>, widget: Widget) where Widget.DataSource == HitsViewModel<Record> {
    self.searcher = searcher
    self.viewModel = viewModel
    self.onError = Observer<Error>()
    widget.hitsSource = viewModel
  }
  
  public convenience init<Widget: HitsWidget>(index: Index, widget: Widget) where Widget.DataSource == HitsViewModel<Record> {
    let query = Query()
    let filterState = FilterState()
    let searcher = SingleIndexSearcher(index: index, query: query, filterState: filterState)

    let viewModel = HitsViewModel<Record>()
    self.init(searcher: searcher, viewModel: viewModel, widget: widget)

    viewModel.connectSearcher(searcher)

  }
  
  public func searchWithQueryText(_ queryText: String) {
    searcher.query = queryText
    searcher.search()
  }
  
}

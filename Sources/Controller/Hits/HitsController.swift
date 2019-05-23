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

  public let searcher: SingleIndexSearcher<Record>
  public let viewModel: HitsViewModel<Record>
  public let onError: Observer<Error>

  public init<Widget: HitsWidget>(searcher: SingleIndexSearcher<Record>, viewModel: HitsViewModel<Record>, widget: Widget) where Widget.DataSource == HitsViewModel<Record> {
    self.searcher = searcher
    self.viewModel = viewModel
    self.onError = Observer<Error>()
    widget.hitsSource = viewModel
  }
  
  public convenience init<Widget: HitsWidget>(index: Index, widget: Widget) where Widget.DataSource == HitsViewModel<Record> {
    let query = Query()
    let filterState = FilterState()
    let searcher = SingleIndexSearcher<Record>(index: index, query: query, filterState: filterState)

    let viewModel = HitsViewModel<Record>()
    self.init(searcher: searcher, viewModel: viewModel, widget: widget)

    searcher.onResultsChanged.subscribe(with: self) { [weak self] (arg) in
      let (metadata, result) = arg
      switch result {
      case .success(let searchResults):
        viewModel.update(searchResults, with: metadata)
        widget.reload()

      case .failure(let error):
        self?.onError.fire(error)
      }
    }.onQueue(.main)

    viewModel.onNewPage.subscribe(with: self) { [weak self] page in
      self?.searcher.indexSearchData.query.page = UInt(page)
      self?.searcher.search()
    }

  }
  
  public func searchWithQueryText(_ queryText: String) {
    searcher.setQuery(text: queryText)
    searcher.indexSearchData.query.page = 0
    searcher.search()
  }
  
}

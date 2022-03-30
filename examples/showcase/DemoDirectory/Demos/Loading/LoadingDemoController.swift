//
//  LoadingDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class LoadingDemoController {
  
  typealias HitType = Movie
  
  let searcher: HitsSearcher
  let hitsConnector: HitsConnector<HitType>
  let queryInputConnector: QueryInputConnector
  let loadingConnector: LoadingConnector
  let statsConnector: StatsConnector

  init<QI: QueryInputController,
       LC: LoadingController,
       SC: LabelStatsController,
       HC: HitsController>(queryInputController: QI,
                           loadingController: LC,
                           statsController: SC,
                           hitsController: HC) where HC.DataSource == HitsInteractor<HitType> {
    searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_movies")
    queryInputConnector = QueryInputConnector(searcher: searcher,
                                              controller: queryInputController)
    loadingConnector = .init(searcher: searcher,
                             controller: loadingController)
    statsConnector = .init(searcher: searcher,
                           controller: statsController,
                           presenter: DefaultPresenter.Stats.present)
    hitsConnector = .init(searcher: searcher,
                          interactor: .init(),
                          controller: hitsController)
    searcher.search()
  }

  
  
}

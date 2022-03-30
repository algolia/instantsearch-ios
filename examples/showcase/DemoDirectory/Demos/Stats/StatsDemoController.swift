//
//  StatsDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class StatsDemoController {
  
  let searcher: HitsSearcher
  let statsConnector: StatsConnector
  let queryInputConnector: QueryInputConnector

  init<QI: QueryInputController, SC: LabelStatsController, ASC: AttributedLabelStatsController>(queryInputController: QI,
                                                                                                statsController: SC,
                                                                                                attributedStatsController: ASC) {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.queryInputConnector = .init(searcher: searcher, controller: queryInputController)
    self.statsConnector = .init(searcher: searcher, controller: statsController) { stats -> String? in
      guard let stats = stats else {
        return nil
      }
      return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
    }
    
    statsConnector.interactor.connectController(attributedStatsController) { stats -> NSAttributedString? in
      guard let stats = stats else {
        return nil
      }
      let string = NSMutableAttributedString()
      string.append(NSAttributedString(string: "\(stats.totalHitsCount)", attributes: [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 15)!]))
      string.append(NSAttributedString(string: "  hits"))
      return string
    }
    
    searcher.search()
    
  }
  
  
}

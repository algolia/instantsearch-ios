//
//  SearchResults+PageMap.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 13/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

struct HitsPage<Item: Codable>: Pageable {

  let index: Int
  let items: [Item]

  init() {
    self.index = 0
    self.items = []
  }

  init(index: Int, items: [Item]) {
    self.index = index
    self.items = items
  }

}

extension HitsPage {

  init(searchResults: HitsExtractable & SearchStatsConvertible) throws {
    self.index = searchResults.searchStats.page
    self.items = try searchResults.extractHits()
  }

}

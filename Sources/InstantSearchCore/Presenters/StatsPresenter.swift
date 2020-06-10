//
//  StatsPresneter.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias StatsPresenter<Output> = Presenter<SearchStats?, Output>

public extension DefaultPresenter {

  enum Stats {

    public static let present: StatsPresenter<String?> = { stats in
      return (stats?.totalHitsCount).flatMap { "\($0) results" }
    }

  }
}

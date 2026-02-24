//
//  IndexNamePresenter.swift
//
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation

public typealias IndexNamePresenter = (String) -> String

public extension DefaultPresenter {
  enum IndexName {
    public static let present: IndexNamePresenter = { indexName in
      return indexName
    }
  }
}

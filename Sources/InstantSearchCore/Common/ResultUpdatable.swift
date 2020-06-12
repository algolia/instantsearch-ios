//
//  ResultUpdatable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 12/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol ResultUpdatable {

  /// Result type
  associatedtype Result

  /// Triggered once result is updated
  var onResultsUpdated: Observer<Result> { get }

  /// Updates result
  /// - returns: Operation encapsulating result update
  func update(_ result: Result) -> Operation

}

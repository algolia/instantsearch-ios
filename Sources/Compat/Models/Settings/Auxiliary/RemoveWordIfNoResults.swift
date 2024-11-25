//
//  RemoveWordIfNoResults.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public enum RemoveWordIfNoResults: String, Codable, URLEncodable {

  /// No specific processing is done when a query does not return any results (default behavior).
  case none

  /// When a query does not return any results, treat the last word as optional. The process is repeated with words N-1, N-2, etc. until there are results, or at most 5 words have been removed.
  case lastWords

  /// When a query does not return any results, treat the first word as optional. The process is repeated with words 2, 3, etc. until there are results, or at most 5 words have been removed.
  case firstWords

  /// When a query does not return any results, make a second attempt treating all words as optional. This is equivalent to transforming the implicit AND operator applied between query words to an OR.
  case allOptional

}

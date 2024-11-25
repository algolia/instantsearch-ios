//
//  QueryType.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public enum QueryType: String, Codable, URLEncodable {
  /**
   Only the last word is interpreted as a prefix (default behavior).
   */
  case prefixLast

  /**
   All query words are interpreted as prefixes.
   This option is not recommended, as it tends to yield counterintuitive results
   and has a negative impact on performance.
   */
  case prefixAll

  /**
   No query word is interpreted as a prefix.
   This option is not recommended, especially in an instant search setup,
   as the user will have to type the entire word(s) before getting any relevant results.
   */
  case prefixNone

}

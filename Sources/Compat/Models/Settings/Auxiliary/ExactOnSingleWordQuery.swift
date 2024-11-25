//
//  ExactOnSingleWordQuery.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public enum ExactOnSingleWordQuery: String, Codable, URLEncodable {

  /// The exact ranking criterion is set to 1 if the query matches exactly an entire attribute value.
  /// For example, if you search for the TV show “Road”, and in your dataset you have 2 records, “Road” and “Road Trip”, only the record with “Road” is considered exact.
  case attribute

  /// The exact ranking criterion is ignored on single word queries.
  case none

  /// The exact ranking criterion is set to 1 if the query word is found in the record.
  /// The query word must be at least 3 characters long and must not be a stop word in any supported language.
  case word
}

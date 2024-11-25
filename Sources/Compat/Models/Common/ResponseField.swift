//
//  ResponseField.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public struct ResponseField: StringOption, ProvidingCustomOption, URLEncodable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  public static var all: Self { .init(rawValue: "*") }
  public static var aroundLatLng: Self { .init(rawValue: #function) }
  public static var automaticRadius: Self { .init(rawValue: #function) }
  public static var exhaustiveFacetsCount: Self { .init(rawValue: #function) }
  public static var facets: Self { .init(rawValue: #function) }
  public static var facetsStats: Self { .init(rawValue: "facets_stats") }
  public static var hits: Self { .init(rawValue: #function) }
  public static var hitsPerPage: Self { .init(rawValue: #function) }
  public static var index: Self { .init(rawValue: #function) }
  public static var length: Self { .init(rawValue: #function) }
  public static var nbHits: Self { .init(rawValue: #function) }
  public static var nbPages: Self { .init(rawValue: #function) }
  public static var offset: Self { .init(rawValue: #function) }
  public static var page: Self { .init(rawValue: #function) }
  public static var params: Self { .init(rawValue: #function) }
  public static var processingTimeMS: Self { .init(rawValue: #function) }
  public static var query: Self { .init(rawValue: #function) }
  public static var queryAfterRemoval: Self { .init(rawValue: #function) }
  public static var userData: Self { .init(rawValue: #function) }

}

//
//  Decodable+InitWithFile.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 03/06/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClientSwift

extension Decodable {

  init(jsonFilename: String) throws {
    let data = try Data(filename: jsonFilename)
    self = try JSONDecoder().decode(Self.self, from: data)
  }

  init(json: JSON) throws {
    let data = try JSONEncoder().encode(json)
    self = try JSONDecoder().decode(Self.self, from: data)
  }

}

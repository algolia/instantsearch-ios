//
//  Movie.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

struct Movie: Codable {
  let title: String
  let year: Int
  let image: URL
  let genre: [String]
}

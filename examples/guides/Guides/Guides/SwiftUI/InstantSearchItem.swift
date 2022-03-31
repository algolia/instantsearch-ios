//
//  InstantSearchItem.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation

struct InstantSearchItem: Codable, Hashable {
  
  let objectID: String
  let name: String
  let brand: String?
  let description: String?
  let image: URL?
  let price: Double?
  
}

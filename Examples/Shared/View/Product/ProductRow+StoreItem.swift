//
//  ProductRow+StoreItem.swift
//  Examples
//
//  Created by Vladislav Fitc on 20/04/2022.
//

import Foundation
import UIKit
import InstantSearchCore
import InstantSearchSwiftUI

extension ProductRow {

  init(storeItemHit: Hit<StoreItem>, configuration: Configuration = .phone) {
    let item = storeItemHit.object
    self.title = storeItemHit.hightlightedString(forKey: "name") ?? HighlightedString(string: item.name)
    self.subtitle = storeItemHit.hightlightedString(forKey: "brand") ?? HighlightedString(string: item.brand ?? "")
    self.details = HighlightedString(string: "")
    self.imageURL = item.images.first
    self.price = item.price
    self.configuration = configuration
  }

}

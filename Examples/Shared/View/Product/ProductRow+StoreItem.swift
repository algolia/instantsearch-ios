//
//  ProductRow+StoreItem.swift
//  Examples
//
//  Created by Vladislav Fitc on 20/04/2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import UIKit

extension ProductRow {
  init(storeItemHit: Hit<StoreItem>, configuration: Configuration = .phone) {
    let item = storeItemHit.object
    title = storeItemHit.hightlightedString(forKey: "name") ?? HighlightedString(string: item.name)
    subtitle = storeItemHit.hightlightedString(forKey: "brand") ?? HighlightedString(string: item.brand ?? "")
    details = HighlightedString(string: "")
    imageURL = item.images.first
    price = item.price
    self.configuration = configuration
  }
  
  init(petSmartItem: Hit<PetSmartStoreItem>, configuration: Configuration = .phone) {
    let item = petSmartItem.object
    title = petSmartItem.hightlightedString(forKey: "name") ?? HighlightedString(string: item.name)
    subtitle = petSmartItem.hightlightedString(forKey: "brand") ?? HighlightedString(string: item.brand ?? "")
    details = HighlightedString(string: "")
    imageURL = item.images.small
    price = (item.price?.number).flatMap(Double.init)
    self.configuration = configuration
  }
}

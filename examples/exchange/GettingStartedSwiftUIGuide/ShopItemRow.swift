//
//  ShopItemRow.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 03/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearch
import InstantSearchSwiftUI
import SDWebImageSwiftUI

struct ShopItemRow: View {
  
  let title: String
  let highlightedTitle: HighlightedString?
  let subtitle: String
  let details: String
  let imageURL: URL?
  let price: Double?

  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 20) {
        WebImage(url: imageURL)
          .resizable()
          .indicator(.activity)
          .scaledToFit()
          .clipped()
          .frame(width: 60, height: 60, alignment: .center)
        VStack(alignment: .leading, spacing: 5) {
          if let highlightedTitle = highlightedTitle {
            Text(highlightedString: highlightedTitle,
                 highlighted: { Text($0).foregroundColor(.blue) })
              .font(.system(.subheadline))
          } else {
            Text(title)
              .font(.system(.headline))
          }
          if !subtitle.isEmpty {
            Text(subtitle)
              .font(.system(.footnote))
              .foregroundColor(.gray)
          }
          if !details.isEmpty {
            Text(details)
              .font(.system(.caption2))
          }
          if let priceString = self.priceString {
            HStack(alignment: .bottom, spacing: 2) {
              Text("\(priceString)€")
                .foregroundColor(.black)
                .font(.system(.caption))
            }
          }
        }.multilineTextAlignment(.leading)
      }
      .frame(maxWidth: .infinity,
             idealHeight: 80,
             maxHeight: 80,
             alignment: .leading)
      .padding(.horizontal, 20)
      Divider()
    }
  }
  
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  var priceString: String? {
    price
      .flatMap(NSNumber.init)
      .flatMap(ShopItemRow.priceFormatter.string)
  }
    
  init(title: String = "",
       subtitle: String = "",
       details: String = "",
       imageURL: URL? = nil,
       highlightedTitle: HighlightedString? = nil,
       price: Double? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.details = details
    self.imageURL = imageURL
    self.highlightedTitle = highlightedTitle
    self.price = price
  }
  
  init<T>(item: T,
          title: KeyPath<T, String>? = nil,
          subtitle: KeyPath<T, String>? = nil,
          details: KeyPath<T, String>? = nil,
          imageURL: KeyPath<T, URL?>? = nil,
          highlightedTitle: KeyPath<T, HighlightedString?>? = nil,
          price: KeyPath<T, Double?>? = nil) {
    self.title = title.flatMap { item[keyPath: $0] } ?? ""
    self.subtitle = subtitle.flatMap { item[keyPath: $0] } ?? ""
    self.details = details.flatMap { item[keyPath: $0] } ?? ""
    self.imageURL = imageURL.flatMap { item[keyPath: $0] }
    self.highlightedTitle = highlightedTitle.flatMap { item[keyPath: $0] }
    self.price = price.flatMap { item[keyPath: $0] }
  }

  init(isitem: Hit<InstantSearchItem>?) {
    guard let item = isitem?.object else {
      self = .init()
      return
    }
    self.title = item.name
    self.subtitle = item.brand ?? ""
    self.details = item.description ?? ""
    self.imageURL = item.image ?? URL(string: "google.com")!
    self.highlightedTitle = isitem?.hightlightedString(forKey: "name")
    self.price = item.price
  }
  
  init(product: Hit<StoreItem>?) {
    guard let item = product?.object else {
      self = .init()
      return
    }
    self.title = item.name
    self.subtitle = item.brand ?? ""
    self.details = ""//item.description ?? ""
    self.imageURL = item.images.first ?? URL(string: "google.com")!
    self.highlightedTitle = product?.hightlightedString(forKey: "name")
    self.price = item.price?.value
  }
  
  init(productHit: Hit<Product>) {
    let product = productHit.object
    title = product.name
    subtitle = product.brand ?? ""
    details = product.description
    imageURL = product.image
    highlightedTitle = productHit.hightlightedString(forKey: "name")
    price = nil
  }
  
}

struct ShopItemRow_Previews : PreviewProvider {
    
  static var previews: some View {
    ShopItemRow(
      title: "Samsung - Galaxy S7 32GB - Black Onyx (AT&T)",
      subtitle: "Samsung",
      details: "Enjoy the exceptional display and all-day power of the Samsung Galaxy S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The Samsung Galaxy S7 smartphone features durable housing and a water-resistant design.",
      imageURL: URL(string: "https://cdn-demo.algolia.com/bestbuy-0118/4897502_sb.jpg")!,
      highlightedTitle: .init(string: "Samsung - <em>Galaxy</em> S7 32GB - Black Onyx (AT&T)"),
      price: 694.99
    )
  }
  
}

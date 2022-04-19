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

struct ShopItemRow: View {
  
  let title: HighlightedString
  let subtitle: HighlightedString
  let details: HighlightedString
  let imageURL: URL?
  let price: Double?
  
  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 20) {
        AsyncImage(url: imageURL,
                   content: { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        },
                   placeholder: {
          if imageURL != nil {
            ProgressView()
          } else {
            Image(systemName: "photo")
          }
        }
        )
        .scaledToFit()
        .frame(width: 60,
               height: 60,
               alignment: .center)
        VStack(alignment: .leading, spacing: 5) {
          Text(highlightedString: title,
               highlighted: { Text($0).foregroundColor(Color(.tintColor)) })
          .font(.system(.subheadline))
          if !subtitle.taggedString.input.isEmpty {
            Text(highlightedString: subtitle,
                 highlighted: { Text($0).foregroundColor(Color(.tintColor)) })
            .font(.system(.footnote))
            .foregroundColor(.gray)
          }
          if !details.taggedString.input.isEmpty {
            Text(highlightedString: details,
                 highlighted: { Text($0).foregroundColor(Color(.tintColor)) })
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
  
  init(title: HighlightedString = .init(string: ""),
       subtitle: HighlightedString = .init(string: ""),
       details: HighlightedString = .init(string: ""),
       imageURL: URL? = nil,
       price: Double? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.details = details
    self.imageURL = imageURL
    self.price = price
  }
  
  init(storeItemHit: Hit<StoreItem>?) {
    guard let item = storeItemHit?.object else {
      self = .init()
      return
    }
    self.title = storeItemHit?.hightlightedString(forKey: "name") ?? HighlightedString(string: item.name)
    self.subtitle = storeItemHit?.hightlightedString(forKey: "brand") ?? HighlightedString(string: item.brand ?? "")
    self.details = HighlightedString(string: "")
    self.imageURL = item.images.first ?? URL(string: "google.com")!
    self.price = item.price
  }
  
  init(productHit: Hit<Product>) {
    let product = productHit.object
    title = productHit.hightlightedString(forKey: "name") ?? HighlightedString(string: product.name)
    subtitle = productHit.hightlightedString(forKey: "brand") ?? HighlightedString(string: product.brand ?? "")
    details = productHit.hightlightedString(forKey: "description") ?? HighlightedString(string: product.description)
    imageURL = product.image
    price = nil
  }
  
}

struct ShopItemRow_Previews : PreviewProvider {
  
  static var previews: some View {
    ShopItemRow(
      title: HighlightedString(string: "Samsung - <em>Galaxy</em> S7 32GB - Black Onyx (AT&T)"),
      subtitle: HighlightedString(string: "Samsung"),
      details: HighlightedString(string: "Enjoy the exceptional display and all-day power of the Samsung <em>Galaxy</em> S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The Samsung <em>Galaxy<em> S7 smartphone features durable housing and a water-resistant design."),
      imageURL: URL(string: "https://cdn-demo.algolia.com/bestbuy-0118/4897502_sb.jpg"),
      price: 694.99
    )
    ShopItemRow(
      title: HighlightedString(string: "<em>Samsung</em> - Galaxy S7 32GB - Black Onyx (AT&T)"),
      subtitle: HighlightedString(string: "<em>Samsung</em>"),
      details: HighlightedString(string: "Enjoy the exceptional display and all-day power of the <em>Samsung</em> Galaxy S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The <em>Samsung</em> Galaxy S7 smartphone features durable housing and a water-resistant design."),
      imageURL: .none,
      price: 694.99
    )
    
  }
  
}

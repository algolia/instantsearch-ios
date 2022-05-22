//
//  ProductRow.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 03/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct ProductRow: View {

  let title: HighlightedString
  let subtitle: HighlightedString
  let details: HighlightedString
  let imageURL: URL?
  let price: Double?
  let configuration: Configuration

  struct Configuration {

    let showDescription: Bool
    let imageWidth: CGFloat
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    static let phone = Self(showDescription: true, imageWidth: 60, horizontalSpacing: 20, verticalSpacing: 5)
    static let watch = Self(showDescription: false, imageWidth: 60, horizontalSpacing: 7, verticalSpacing: 5)
    // swiftlint:disable identifier_name
    static let tv = Self(showDescription: true, imageWidth: 200, horizontalSpacing: 30, verticalSpacing: 10)

  }

  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: configuration.horizontalSpacing) {
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
        .cornerRadius(10)
        .scaledToFit()
        .frame(maxWidth: configuration.imageWidth,
               alignment: .center)
        VStack(alignment: .leading, spacing: configuration.verticalSpacing) {
          Text(highlightedString: title,
               highlighted: { Text($0).foregroundColor(Color(.algoliaCyan)) })
          .font(.system(.headline))
          if !subtitle.taggedString.input.isEmpty {
            Text(highlightedString: subtitle,
                 highlighted: { Text($0).foregroundColor(Color(.algoliaCyan)) })
            .font(.system(.subheadline))
          }
          if !details.taggedString.input.isEmpty, configuration.showDescription {
            Text(highlightedString: details,
                 highlighted: { Text($0).foregroundColor(Color(.algoliaCyan)) })
            .font(.system(.caption))
          }
          if let price = price {
            Text(String(format: "%.2f €", price))
              .font(.system(.callout))
          }
        }.multilineTextAlignment(.leading)
        Spacer()
      }
      Spacer()
    }
  }

  init(title: HighlightedString = .init(string: ""),
       subtitle: HighlightedString = .init(string: ""),
       details: HighlightedString = .init(string: ""),
       imageURL: URL? = nil,
       price: Double? = nil,
       configuration: Configuration = .phone) {
    self.title = title
    self.subtitle = subtitle
    self.details = details
    self.imageURL = imageURL
    self.price = price
    self.configuration = configuration
  }

}

// swiftlint:disable line_length
struct ProductRow_Previews: PreviewProvider {

  static var previews: some View {
    ProductRow(
      title: HighlightedString(string: "Samsung - <em>Galaxy</em> S7 32GB - Black Onyx (AT&T)"),
      subtitle: HighlightedString(string: "Samsung"),
      details: HighlightedString(string: "Enjoy the exceptional display and all-day power of the Samsung <em>Galaxy</em> S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The Samsung <em>Galaxy<em> S7 smartphone features durable housing and a water-resistant design."),
      imageURL: URL(string: "https://cdn-demo.algolia.com/bestbuy-0118/4897502_sb.jpg"),
      price: 694.99
    )
    ProductRow(
      title: HighlightedString(string: "<em>Samsung</em> - Galaxy S7 32GB - Black Onyx (AT&T)"),
      subtitle: HighlightedString(string: "<em>Samsung</em>"),
      details: HighlightedString(string: "Enjoy the exceptional display and all-day power of the <em>Samsung</em> Galaxy S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The <em>Samsung</em> Galaxy S7 smartphone features durable housing and a water-resistant design."),
      imageURL: .none,
      price: 694.99
    )

  }

}

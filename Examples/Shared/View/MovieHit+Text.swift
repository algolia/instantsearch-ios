//
//  MovieHit+Text.swift
//  Examples
//
//  Created by Vladislav Fitc on 06/05/2022.
//

import Foundation
import AlgoliaSearchClient
import SwiftUI
import InstantSearchSwiftUI

extension Hit where T == Movie {

  var titleText: Text {
    if let highlightedTitle = hightlightedString(forKey: "title") {
      return Text(highlightedString: highlightedTitle,
                  highlighted: { Text($0).foregroundColor(Color(.algoliaCyan)) })
    } else {
      return Text(object.title)
    }
  }

  var genresText: Text {
    if let highlightedGenres = highlightResult?.value(forKey: "genres"), case .array(let higligtedGenres) = highlightedGenres {
      let highlightedTexts = higligtedGenres.compactMap({ $0.value }).map(\.value).map { Text(highlightedString: $0, highlighted: { Text($0).foregroundColor(Color(.algoliaCyan)) }) }
      if highlightedTexts.count > 1 {
        return highlightedTexts.suffix(from: 1).reduce(highlightedTexts.first!, { $0 + Text(", ") + $1 })
      } else {
        return highlightedTexts.first!
      }
    } else {
      return Text(object.genres.joined(separator: ", "))
    }
  }

}

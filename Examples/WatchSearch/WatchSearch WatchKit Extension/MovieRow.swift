//
//  MovieRow.swift
//  WatchSearch WatchKit Extension
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Foundation
import InstantSearchCore
import SwiftUI

struct MovieRow: View {

  let movieHit: Hit<Movie>

  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      AsyncImage(url: movieHit.object.imageURL,
                 content: { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                 },
                 placeholder: {
                  Image(systemName: "photo")
                 }
      )
      .cornerRadius(10)
      .scaledToFit()
      .frame(maxWidth: 60)
      VStack(alignment: .leading, spacing: 3) {
        movieHit.titleText
          .font(.system(size: 14, weight: .bold))
        movieHit.genresText
          .font(.system(size: 12))
          .foregroundColor(.gray)
        Spacer()
        HStack(spacing: 3) {
          Image(systemName: "star.circle")
          Text(String(format: "%.1f", movieHit.object.note))
        }
        .foregroundColor(.orange)
        Spacer()
      }
      Spacer()
    }
  }

}

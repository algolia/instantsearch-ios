//
//  MovieRow.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Foundation
import InstantSearchCore
import SwiftUI

struct MovieRow: View {

  let movieHit: Hit<Movie>

  var body: some View {
    VStack {
      HStack {
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
        .frame(maxWidth: 150)
        VStack(alignment: .leading, spacing: 9) {
          movieHit.titleText
            .font(.title3)
          movieHit.genresText
            .font(.footnote)
            .foregroundColor(.gray)
          HStack(spacing: 10) {
            Image(systemName: "star.circle")
            Text(String(format: "%.1f", movieHit.object.note))
          }
          .padding(.top, 30)
          .font(.title3)
          .foregroundColor(.orange)
          Spacer()
        }
        Spacer()
      }
    }

  }

}

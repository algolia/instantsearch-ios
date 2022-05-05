//
//  MovieRow.swift
//  Examples
//
//  Created by Vladislav Fitc on 05/05/2022.
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
                   })
                  .cornerRadius(10)
                  .scaledToFit()
                  .frame(maxWidth: 150,
                         alignment: .center)
        VStack(alignment: .leading, spacing: 9) {
          Text(movieHit.object.title)
            .font(.title3)
          Text(movieHit.object.genres.joined(separator: ", "))
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


//
//  Movie.swift
//  Examples
//
//  Created by Vladislav Fitc on 05/05/2022.
//

import Foundation

struct Movie: Codable {

  let title: String
  let genres: [String]
  let posterPath: String
  let note: Float

  var imageURL: URL {
    return URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)")!
  }

  enum CodingKeys: String, CodingKey {
    case title
    case genres
    case posterPath = "poster_path"
    case note = "vote_average"
  }

}

//
//  String+Random.swift
//
//
//  Created by Vladislav Fitc on 23/10/2020.
//

import Foundation

extension String {
  static func random(length: Int = 10) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in letters.randomElement()! })
  }
}

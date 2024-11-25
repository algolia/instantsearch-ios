//
//  DynamicKey.swift
//  
//
//  Created by Vladislav Fitc on 27/03/2020.
//

import Foundation

struct DynamicKey: CodingKey {

  var intValue: Int?
  var stringValue: String

  init(intValue: Int) {
    self.intValue = intValue
    self.stringValue = String(intValue)
  }

  init(stringValue: String) {
    self.stringValue = stringValue
  }

}

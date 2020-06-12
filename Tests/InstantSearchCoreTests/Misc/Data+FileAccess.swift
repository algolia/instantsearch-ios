//
//  Data+FileAccess.swift
//
//
//  Created by Vladislav Fitc on 19/03/2020.
//

import Foundation

extension Data {

  init(filename: String) throws {
    let thisSourceFile = URL(fileURLWithPath: #file)
    let thisDirectory = thisSourceFile.deletingLastPathComponent()
    let url = thisDirectory.appendingPathComponent(filename)
    self = try Data(contentsOf: url)
  }

}

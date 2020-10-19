//
//  JSONFilePackageStorage.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation

class JSONFilePackageStorage<Item: Codable>: Storage {

  let fileURL: URL
  let fileManager: FileManager
  let encoder: JSONEncoder
  let decoder: JSONDecoder

  init(filename: String) throws {

    fileManager = .default

    #if os(iOS)
    let url = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last
    #else
    let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).last
    #endif

    guard let unwrappedURL = url else {
      throw Error.directoryURLFetchFail
    }

    fileURL = unwrappedURL.appendingPathComponent(filename)
    encoder = JSONEncoder()
    decoder = JSONDecoder()
    encoder.outputFormatting = .prettyPrinted
  }

  func store(_ item: Item) throws {
    guard let data = try? encoder.encode(item) else { return }
    fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
  }

  func load() throws -> Item {
    let data = try Data(contentsOf: fileURL)
    let item = try decoder.decode(Item.self, from: data)
    return item
  }

  enum Error: Swift.Error {
    case directoryURLFetchFail
    case storeFail(Swift.Error)
    case loadFail(Swift.Error)
  }

}

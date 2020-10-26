//
//  Storage.swift
//  
//
//  Created by Vladislav Fitc on 17/10/2020.
//

import Foundation

protocol Storage {

  associatedtype Item

  func store(_ item: Item) throws
  func load() throws -> Item

}

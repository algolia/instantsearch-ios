//
//  Connection.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol Connection {

  func connect()
  func disconnect()

}

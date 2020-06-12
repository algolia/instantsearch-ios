//
//  EventInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 10/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol EventInteractor {
  associatedtype Arg

  var onTriggered: Observer<Arg> { get }

}

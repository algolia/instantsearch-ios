//
//  Signals+Observable.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension Signal: Observable {
  public typealias ParameterType = T
}

extension SignalSubscription: Observation {}

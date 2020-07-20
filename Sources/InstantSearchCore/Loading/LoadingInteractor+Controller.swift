//
//  LoadingInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension LoadingInteractor {

  @discardableResult func connectController<Controller: LoadingController>(_ controller: Controller) -> ControllerConnection<Controller, Bool> {
    return connectController(controller) { $0 }
  }

}

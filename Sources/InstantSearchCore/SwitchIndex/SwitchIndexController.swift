//
//  SwitchIndexController.swift
//  
//
//  Created by Vladislav Fitc on 12/09/2021.
//

import Foundation

public protocol SwitchIndexController: AnyObject {

  /// Closure to trigger when an index selected
  var select: (IndexName) -> Void { get set }

  /// External update of the indices names list and the currently selected index name
  func set(indexNames: [IndexName], selected: IndexName)

}

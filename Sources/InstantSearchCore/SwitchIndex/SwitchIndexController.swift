//
//  SwitchIndexController.swift
//  
//
//  Created by Vladislav Fitc on 12/09/2021.
//

import Foundation

/// Controller interfacing with a switch index view
public protocol SwitchIndexController: AnyObject {

  /// Closure to trigger when an index selected
  var selectIndexWithName: (IndexName) -> Void { get set }

  /// External update of the indices names list and the currently selected index name
  func set(indicesNames: [IndexName], selected: IndexName)

}

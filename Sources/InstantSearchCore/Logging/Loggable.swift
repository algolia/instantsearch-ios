//
//  Loggable.swift
//  
//
//  Created by Vladislav Fitc on 11/06/2020.
//

import Foundation

public protocol Loggable {

  var minSeverityLevel: LogLevel { get set }

  func log(level: LogLevel, message: String)

}

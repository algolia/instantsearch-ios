//
//  ResultContainer.swift
//
//
//  Created by Vladislav Fitc on 10.03.2020.
//

import Foundation

public protocol ResultContainer {

  associatedtype ResultValue

  var result: Result<ResultValue, Swift.Error> { get }

}

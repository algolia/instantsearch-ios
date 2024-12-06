//
//  ABTestDeletion.swift
//  
//
//  Created by Vladislav Fitc on 28/05/2020.
//

import Foundation

public struct ABTestDeletion: IndexTask, Codable, IndexNameContainer {

  /// Generated ABTestID of the ABTest.
  public let abTestID: ABTestID

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

  /// Base IndexName for the ABTest.
  public let indexName: IndexName

  enum CodingKeys: String, CodingKey {
    case abTestID
    case taskID
    case indexName = "index"
  }

}

protocol IndexNameContainer {

  var indexName: IndexName { get }

}

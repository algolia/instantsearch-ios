//
//  CellConfigurator.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 29/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit

public protocol CellConfigurator {
  associatedtype Model: Codable
  init(model: Model, indexPath: IndexPath)
  static var cellIdentifier: String { get }
}

extension CellConfigurator {
  static var cellIdentifier: String { return "\(Self.self)" }
}

public protocol TableViewCellConfigurator: CellConfigurator {
  associatedtype Cell: UITableViewCell
  var cellHeight: CGFloat { get }
  func configure(_ cell: Cell)
}

extension TableViewCellConfigurator {
  var cellHeight: CGFloat { return 44 }
}

public protocol CollectionViewCellConfigurator: CellConfigurator {
  associatedtype Cell: UICollectionViewCell
  var cellSize: CGSize { get }
  func configure(_ cell: Cell)
}

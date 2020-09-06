//
//  CellConfigurator.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 29/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public protocol CellConfigurable {
  associatedtype Model: Codable
  init(model: Model, indexPath: IndexPath)
  static var cellIdentifier: String { get }
}

public extension CellConfigurable {
  static var cellIdentifier: String { return "\(Self.self)" }
}

public protocol TableViewCellConfigurable: CellConfigurable {
  associatedtype Cell: UITableViewCell = UITableViewCell
  var cellHeight: CGFloat { get }
  func configure(_ cell: Cell)
}

public extension TableViewCellConfigurable {
  var cellHeight: CGFloat { return 44 }
}

public protocol CollectionViewCellConfigurable: CellConfigurable {
  associatedtype Cell: UICollectionViewCell = UICollectionViewCell
  var cellSize: CGSize { get }
  func configure(_ cell: Cell)
}
#endif

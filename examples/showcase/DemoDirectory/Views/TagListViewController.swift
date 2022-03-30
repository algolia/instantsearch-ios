//
//  TagListViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit
import TagListView

open class TagListController: NSObject, ItemListController, TagListViewDelegate {

  public typealias Item = FilterAndID

  open var onRemoveItem: ((FilterAndID) -> Void)?

  public let tagListView: TagListView

  public var items: [FilterAndID] = []

  public init(tagListView: TagListView) {
    self.tagListView = tagListView
    super.init()
    tagListView.delegate = self
    setupUI()
  }

  open func setItems(_ item: [FilterAndID]) {
    items = Array(item)
  }

  open func reload() {
    tagListView.removeAllTags()
    let tagViews = tagListView.addTags(items.map { $0.text })
    for (index, tagView) in tagViews.enumerated() {
      tagView.tag = index
    }
  }

  public func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
    let tag = tagView.tag
    let item = items[tag]

    onRemoveItem?(item)
  }

}

extension TagListController {
  func setupUI() {
    tagListView.textFont = UIFont.boldSystemFont(ofSize: 20)
    tagListView.tagBackgroundColor = UIColor(red: 98/255, green: 146/255, blue: 226/255, alpha: 1)
    tagListView.cornerRadius = 5
    tagListView.marginX = 20
    tagListView.paddingX = 5
    tagListView.enableRemoveButton = true

  }
}

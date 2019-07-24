//
//  SearchBarController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class SearchBarController: NSObject, QueryInputController {

  public var onQueryChanged: ((String?) -> Void)?
  public var onQuerySubmitted: ((String?) -> Void)?
  
  public let searchBar: UISearchBar

  public init(searchBar: UISearchBar) {
    self.searchBar = searchBar
    super.init()
    setupSearchBar()

  }
  
  public func setQuery(_ query: String?) {
    searchBar.text = query
  }
  
  private func setupSearchBar() {
    searchBar.delegate = self
    searchBar.returnKeyType = .search
  }

}

extension SearchBarController: UISearchBarDelegate {

  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    onQueryChanged?(searchText)
  }

  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    onQuerySubmitted?(searchBar.text)
  }

}

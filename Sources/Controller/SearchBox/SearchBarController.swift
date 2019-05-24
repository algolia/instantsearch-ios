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

public class SearchBarController: NSObject, SearchableController {

  public let onSearch: Observer<String>

  let searchBar: UISearchBar

  public init(searchBar: UISearchBar) {
    self.searchBar = searchBar
    self.onSearch = Observer()
    super.init()
    searchBar.delegate = self
  }

}

extension SearchBarController: UISearchBarDelegate {

  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    onSearch.fire(searchText)
  }

}

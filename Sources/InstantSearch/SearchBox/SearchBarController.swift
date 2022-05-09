//
//  SearchBarController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

@available(iOS, deprecated: 13.0, message: "Use TextFieldController instead")
public class SearchBarController: NSObject, SearchBoxController {

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
#endif

//
//  SearchControllerDemo.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 10/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

@available(iOS 13.0, *)
class FacetSearchTextFieldConnection: Connection {
  
  let filterState: FilterState
  let searchTextField: UISearchTextField
  var lastTokens: Set<UISearchToken>
    
  init(filterState: FilterState, searchTextField: UISearchTextField) {
    self.filterState = filterState
    self.searchTextField = searchTextField
    self.lastTokens = Set(searchTextField.tokens)
  }
  
  func connect() {
    filterState.onChange.subscribe(with: self) { (connection, filters) in
      connection.searchTextField.tokens = connection.filterState.getFilters().map(UISearchToken.init)
      connection.lastTokens = Set(connection.searchTextField.tokens)
    }
    searchTextField.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
  }
  
  func disconnect() {
    filterState.onChange.cancelSubscription(for: searchTextField)
    searchTextField.removeTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
  }

  
  @objc func didChangeText(_ textField: UISearchTextField) {
    let removedTokens = lastTokens.subtracting(Set(textField.tokens))
    guard !removedTokens.isEmpty else { return }
    for token in removedTokens {
      _ = token.filter.flatMap(filterState.remove)
      lastTokens.remove(token)
    }
    filterState.notifyChange()
  }
    
}

@available(iOS 13.0, *)
extension UISearchToken {
  
  convenience init(filter: Filter) {
    switch filter {
    case .facet(let facetFilter):
      self.init(icon: .none, text: facetFilter.value.description)
      self.representedObject = facetFilter
      
    case .numeric(let numericFilter):
      self.init(icon: .none, text: numericFilter.description)
      self.representedObject = numericFilter
      
    case .tag(let tagFilter):
      self.init(icon: .none, text: tagFilter.description)
      self.representedObject = tagFilter
    }
  }
  
  var filter: FilterType? {
    switch representedObject {
    case let facetFilter as Filter.Facet:
      return facetFilter
      
    case let numericFilter as Filter.Numeric:
      return numericFilter
      
    case let tagFilter as Filter.Tag:
      return tagFilter
      
    default:
      return nil
    }
  }
  
}

class SearchControllerDemoViewController: UIViewController {
  
  let searchController: UISearchController
  let filterState: FilterState
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchController = .init(searchResultsController: nil)
    filterState = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

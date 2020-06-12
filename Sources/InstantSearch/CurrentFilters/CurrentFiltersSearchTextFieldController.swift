//
//  CurrentFiltersSearchTextFieldController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 29/01/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

@available(iOS 13.0, *)
public class SearchTextFieldCurrentFiltersController: CurrentFiltersController {

  public var items: [FilterAndID] = []
  public var onRemoveItem: ((FilterAndID) -> Void)?
  public let searchTextField: UISearchTextField

  public init(searchTextField: UISearchTextField) {
    self.searchTextField = searchTextField
    searchTextField.addTarget(self, action: #selector(didChange), for: .editingChanged)
  }

  public convenience init(searchBar: UISearchBar) {
    self.init(searchTextField: searchBar.searchTextField)
  }

  public func setItems(_ items: [FilterAndID]) {
    self.items = Array(items)
  }

  public func reload() {
    let tokens = items
      .enumerated()
      .map { (index, item) -> UISearchToken in
        let token = UISearchToken(icon: .none, text: item.text)
      	token.representedObject = index
        return token
    }
    searchTextField.tokens = tokens
  }

  @objc private func didChange(_ textField: UITextField) {
    let previousFiltersIndices = Set(0..<items.count)
    let currentFiltersIndices = Set(searchTextField.tokens.compactMap { $0.representedObject as? Int })
    guard currentFiltersIndices.count < previousFiltersIndices.count else { return }
    previousFiltersIndices
      .subtracting(currentFiltersIndices)
      .map { items[$0] }
      .forEach { onRemoveItem?($0) }
  }

}
#endif

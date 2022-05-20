//
//  TextfieldController.swift
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

public class TextFieldController: NSObject, SearchBoxController {

  public var onQueryChanged: ((String?) -> Void)?
  public var onQuerySubmitted: ((String?) -> Void)?

  public let textField: UITextField

  public init(textField: UITextField) {
    self.textField = textField
    super.init()
    setupTextField()
  }

#if os(iOS) || os(macOS)
  @available(iOS 13.0, *)
  public convenience init(searchBar: UISearchBar) {
    self.init(textField: searchBar.searchTextField)
  }
#endif

  public func setQuery(_ query: String?) {
    textField.text = query
  }

  @objc func textFieldTextChanged(textField: UITextField) {
    guard let searchText = textField.text else { return }
    onQueryChanged?(searchText)
  }

  @objc func textFieldSubmitted(textField: UITextField) {
    guard let searchText = textField.text else { return }
    onQuerySubmitted?(searchText)
  }

  private func setupTextField() {
    textField.returnKeyType = .search
    textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
    textField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingDidEndOnExit)
  }

}
#endif

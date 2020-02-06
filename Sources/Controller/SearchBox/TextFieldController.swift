//
//  TextfieldController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class TextFieldController: NSObject, QueryInputController {
  
  public var onQueryChanged: ((String?) -> Void)?
  public var onQuerySubmitted: ((String?) -> Void)?
  
  let textField: UITextField

  public init(textField: UITextField) {
    self.textField = textField
    super.init()
    setupTextField()
  }
  
  @available(iOS 13.0, *)
  public convenience init(searchBar: UISearchBar) {
    self.init(textField: searchBar.searchTextField)
  }
  
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
    textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingDidEnd)
    textField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingDidEndOnExit)
  }
  
}

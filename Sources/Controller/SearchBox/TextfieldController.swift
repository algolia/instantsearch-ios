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

public class TextFieldController: SearchableController {

  public let onSearch: Observer<String>

  public init (textField: UITextField) {
    onSearch = Observer()
    textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
  }

  @objc func textFieldTextChanged(textField: UITextField) {
    guard let searchText = textField.text else { return }
    onSearch.fire(searchText)
  }
}

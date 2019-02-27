//
//  SearchWidgets.swift
//  InstantSearch
//
//  Created by Guy Daher on 26/02/2019.
//

import Foundation
import UIKit

public typealias TextChangeHandler = (String) -> Void

protocol TextChangeDelegate {
  var textChangeObservations: [TextChangeHandler] { get set }
  mutating func subscribeToTextChangeHandler(using closure: @escaping TextChangeHandler)
  mutating func clearTextChangeObservations()
}

extension TextChangeDelegate {
  public mutating func subscribeToTextChangeHandler(using closure: @escaping TextChangeHandler) {
    textChangeObservations.append(closure)
  }

  public mutating func clearTextChangeObservations() {
    textChangeObservations = []
  }
}

public class SearchBarWidgetV2: NSObject, UISearchBarDelegate, TextChangeDelegate {

  var textChangeObservations = [TextChangeHandler]()

  public init (searchBar: UISearchBar) {
    super.init()
    searchBar.delegate = self
  }

  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    textChangeObservations.forEach { $0(searchText) }
  }
}

public class TextFieldWidgetV2 {

  var textChangeObservations = [TextChangeHandler]()

  public init (textField: UITextField) {
    textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
  }

  @objc func textFieldTextChanged(textField: UITextField) {
    guard let searchText = textField.text else { return }
    textChangeObservations.forEach { $0(searchText) }
  }

  public func subscribeToTextChangeHandler(using closure: @escaping TextChangeHandler) {
    textChangeObservations.append(closure)
  }
}

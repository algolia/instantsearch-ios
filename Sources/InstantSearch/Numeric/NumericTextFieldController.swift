//
//  FilterYearView.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS) || os(tvOS))
import UIKit

public class NumericTextFieldController: NSObject, NumberController {

  public typealias Item = Int

  public func setItem(_ item: Int) {
    self.textField.text = "\(item)"
  }

  var computation: Computation<Int>?

  public func setComputation(computation: Computation<Int>) {
    self.computation = computation
  }

  public func setBounds(bounds: ClosedRange<Int>?) {
    textField.placeholder = bounds.flatMap { "\($0.lowerBound) - \($0.upperBound)" }
  }

  public let textField: UITextField

  public init(textField: UITextField = .init()) {
    self.textField = textField
    super.init()
    #if (os(iOS) || os(macOS))
    textField.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
    #endif
  }

  @objc func doneButtonTappedForMyNumericTextField() {
    guard let text = textField.text, let intText = Int(text) else { return }
    self.computation?.just(value: intText)
    textField.resignFirstResponder()
  }

  public func invalidate() {
    textField.text = nil
  }

}
#if (os(iOS) || os(macOS))
extension UITextField {
  func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
    let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
    let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

    let toolbar: UIToolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.items = [
      UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
      UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
    ]
    toolbar.sizeToFit()

    self.inputAccessoryView = toolbar
  }

  // Default actions:
  @objc func doneButtonTapped() { self.resignFirstResponder() }
  @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
#endif
#endif

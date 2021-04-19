//
//  SearchBar.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
import SwiftUI

#if os(iOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SearchBar: View {
  
  @Binding public var text: String
  @Binding public var isEditing: Bool
  
  private let placeholder: String
  private var onSubmit: () -> Void
  
  public init(text: Binding<String>,
              isEditing: Binding<Bool>,
              placeholder: String = "Search ...",
              onSubmit: @escaping () -> Void = {}) {
    self._text = text
    self._isEditing = isEditing
    self.placeholder = placeholder
    self.onSubmit = onSubmit
  }
  
  public var body: some View {
    HStack {
      TextField(placeholder, text: $text, onCommit: {
        onSubmit()
        isEditing = false
      })
      .padding(7)
      .padding(.horizontal, 25)
      .background(Color(.systemGray5))
      .cornerRadius(8)
      .overlay(
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
            .disabled(true)
          if isEditing && !text.isEmpty {
            Button(action: {
              text = ""
            }) {
              Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
            }
          }
        }
      )
      .padding(.horizontal)
      .onTapGesture {
        isEditing = true
      }
      if isEditing {
        Button(action: {
          isEditing = false
        }) {
          Text("Cancel")
        }
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .animation(.default)
      }
    }
  }
  
}

#endif

#if canImport(UIKit)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
  func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif

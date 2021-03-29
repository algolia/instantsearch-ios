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
  
  @State private var isEditing = false
  @Binding public var text: String

  public var body: some View {
    HStack {
      ZStack {
        TextField("Search ...", text: $text)
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
                  self.text = ""
                }) {
                  Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
                }
              }
            }
          )
          .padding(.horizontal, 10)
          .onTapGesture {
            self.isEditing = true
          }

      }
      if isEditing {
        Button(action: {
          self.isEditing = false
          self.text = ""
          self.hideKeyboard()
        }) {
          Text("Cancel")
        }
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .animation(.default)
      }
    }
    .background(Color(.systemBackground))
  }
  
  public init(text: Binding<String>) {
    self._text = text
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

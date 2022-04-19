//
//  SearchBar.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64)) && !os(tvOS)
import Combine
import SwiftUI

/// A specialized view for receiving search query text from the user.
@available(iOS 13.0, OSX 11.0, tvOS 13.0, watchOS 6.0, *)
public struct SearchBar: View {

  /// Search query text
  @Binding public var text: String

  /// Whether the search bar is in the editing state
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
                   },
                   label: {
                    Image(systemName: "multiply.circle.fill")
                      .foregroundColor(.gray)
                      .padding(.trailing, 8)
                   })
          }
        }
      )
      .onTapGesture {
        isEditing = true
      }
      .background(Color(.sRGB, red: 239/255, green: 239/255, blue: 240/255, opacity: 1))
      .cornerRadius(10)
      if isEditing {
        Button(action: {
                isEditing = false
               },
               label: {
                Text("Cancel")
               })
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .animation(.default)
      }
    }
  }

}
#endif

//
//  SearchDemoContainerView.swift
//  Examples
//
//  Created by Vladislav Fitc on 07.04.2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI


struct SearchDemoContainerView<Content: View>: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  
  public var content: () -> Content
  
  public init(_ queryInputController: QueryInputObservableController,
              @ViewBuilder content: @escaping () -> Content) {
    self.queryInputController = queryInputController
    self.content = content
  }
  
  var body: some View {
    NavigationView {
      content()
    }
    .searchable(text: $queryInputController.query)
  }
}

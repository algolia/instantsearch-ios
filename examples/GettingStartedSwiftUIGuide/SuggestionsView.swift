//
//  SuggestionsView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct SuggestionsView: View {
  
  @Binding var query: String
  @Binding var isEditing: Bool
  @ObservedObject var suggestionsController: HitsObservableController<QuerySuggestion>
  
  var body: some View {
    HitsList(suggestionsController) { (hit, _) in
      if let querySuggestion = hit {
        SuggestionRow(suggestion: querySuggestion) { suggestion in
          query = suggestion
          isEditing = false
        } onTypeAhead: { suggestion in
          query = suggestion
        }
        Divider()
      } else {
        EmptyView()
      }
    }
  }
  
}

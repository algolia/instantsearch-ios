//
//  CodeExchangeDemo.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import UIKit
import AlgoliaSearchClient

protocol DemoProtocol {

  var objectID: ObjectID { get }
  var name: String { get }
  var type: String { get }

}

struct Demo: Codable, DemoProtocol {

  let objectID: ObjectID
  let name: String
  let type: String

  // swiftlint:disable type_name
  enum ID: String {
    case showcaseImperative = "showcase_imperative_ui"
    case showCaseDeclarative = "showcase_declarative_ui"
    case guideInsights = "guide_insights"
    case guideGettingStarted  = "guide_getting_started"
    case guideDeclarativeUI  = "guide_declarative_ui"
    case codexVoiceSearch = "codex_voice_search"
    case codexQuerySuggestionsRecent = "codex_query_suggestions_recent"
    case codexQuerySuggestionsHits = "codex_query_suggestions_hits"
    case codexQuerySuggestionsCategories = "codex_query_suggestions_categories"
    case codexQuerySuggestions = "codex_query_suggestions"
    case codexMultipleIndex = "codex_multiple_index"
    case codexCategoriesHits = "codex_categories_hits"
  }

}

//
//  CodeExchangeDemo.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import UIKit

enum CodeExchangeDemo: Int, CaseIterable {
  
  case querySuggestions
  case voiceSearch
  case multiIndex
  case querySuggestionsAndCategories
  case querySuggestionsAndRecentSearches
  case querySuggestionsAndHits
  
  var title: String {
    switch self {
    case .querySuggestions:
      return "Query suggestions"
    case .voiceSearch:
      return "Voice search"
    case .multiIndex:
      return "Multi-index search"
    case .querySuggestionsAndCategories:
      return "Query suggestions and categories"
    case .querySuggestionsAndRecentSearches:
      return "Query suggestions and recent searches"
    case .querySuggestionsAndHits:
      return "Query suggestions and hits"
    }
  }
  
  var viewController: UIViewController {
    switch self {
    case .querySuggestions:
      return QuerySuggestions.SearchViewController()
    
    case .voiceSearch:
      return VoiceSearch.SearchViewController()
      
    case .multiIndex:
      return MultiIndex.SearchViewController()
      
    case .querySuggestionsAndCategories:
      return QuerySuggestionsCategories.SearchViewController()
      
    case .querySuggestionsAndRecentSearches:
      return QuerySuggestionsAndRecentSearches.SearchViewController()
      
    case .querySuggestionsAndHits:
      return QuerySuggestionsAndHits.SearchViewController()
    }
  }
  
}

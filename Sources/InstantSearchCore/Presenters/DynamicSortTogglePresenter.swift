//
//  DynamicSortTogglePresenter.swift
//  
//
//  Created by Vladislav Fitc on 08/02/2021.
//

import Foundation

public extension DefaultPresenter {
  
  enum DynamicSortToggle {
    
    public static func present(_ priority: DynamicSortPriority?) -> (String, String)? {
      switch priority {
      case .some(.hitsCount):
        return ("Currently showing all results.", "Show more relevant results")
      case .some(.relevancy):
        return ("We removed some search results to show you the most relevants ones.", "Show all results")
      default:
        return nil
      }
    }
    
  }

}

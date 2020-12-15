//
//  BaseSearcher+TextualQueryProvider.swift
//  
//
//  Created by Vladislav Fitc on 15/12/2020.
//

import Foundation

public extension BaseSearcher where Service.Request: TextualQueryProvider {
  
  var query: String? {
    
    get {
      request.textualQuery
    }

    set {
      let oldValue = request.textualQuery
      request.textualQuery = newValue
      if oldValue != newValue {
        onQueryChanged.fire(newValue)
      }
    }
    
  }
  
}

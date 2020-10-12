//
//  QueryRuleCustomDataInteractor.swift
//  
//
//  Created by Vladislav Fitc on 10/10/2020.
//

import Foundation

/// Component encapsulating the logic applied to the custom model
public class QueryRuleCustomDataInteractor<Model: Decodable>: ItemInteractor<Model?> {

  public override init(item: Model? = nil) {
    super.init(item: item)
  }
  

  
}

extension QueryRuleCustomDataInteractor {
  
  func extractModel(from searchResponse: SearchResponse) {
    if let userData = searchResponse.userData,
       let model = userData.compactMap({ try? Model(json: $0) }).first {
      item = model
    } else {
      item = nil
    }
  }
  
}

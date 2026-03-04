//
//  QueryRuleCustomDataInteractor.swift
//
//
//  Created by Vladislav Fitc on 10/10/2020.
//

import Foundation

/// Component encapsulating the logic applied to the custom model
public class QueryRuleCustomDataInteractor<Model: Decodable>: ItemInteractor<Model?> {
  override public init(item: Model? = nil) {
    super.init(item: item)
    Telemetry.shared.trace(type: .queryRuleCustomData,
                           parameters: [
                             item == nil ? .none : .item
                           ])
  }
}

extension QueryRuleCustomDataInteractor {
  func extractModel(from searchResponse: SearchResponse<SearchHit>) {
    // userData is AnyCodable - extract array if present
    if let userData = searchResponse.userData?.value as? [[String: Any]] {
      if let model = userData.compactMap({ dict -> Model? in
        guard let data = try? JSONSerialization.data(withJSONObject: dict),
              let decoded = try? JSONDecoder().decode(Model.self, from: data) else {
          return nil
        }
        return decoded
      }).first {
        item = model
        return
      }
    }
    item = nil
  }
}

public extension QueryRuleCustomDataInteractor {
  /**
    Establishes a connection with the controller
    - Parameters:
      - controller: Controller interfacing with a concrete custom data view
    - Returns: Established connection
   */
  @discardableResult func connectController<Controller: ItemController>(_ controller: Controller) -> ItemInteractor<Model?>.ControllerConnection<Controller, Model?> {
    super.connectController(controller, presenter: { $0 })
  }
}

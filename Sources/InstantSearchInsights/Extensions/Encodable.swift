//
//  Encodable.swift
//  Insights
//
//  Created by Vladislav Fitc on 02/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

extension Encodable {

    func jsonObject() throws -> Any {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

}

extension Dictionary where Key == String, Value == Any {

    init?<T: Encodable>(_ encodable: T) {
        guard let data = try? JSONEncoder().encode(encodable) else { return nil }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
            return nil
        }
        self = dictionary
    }

}

extension Array where Element == Any {

    init?<T: Encodable>(encodable: T) {
        guard let data = try? JSONEncoder().encode(encodable) else { return nil }
        guard let array = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [Any] else {
            return nil
        }
        self = array
    }

}

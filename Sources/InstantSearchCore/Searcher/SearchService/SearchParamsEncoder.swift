//
//  SearchParamsEncoder.swift
//  InstantSearchCore
//

import Foundation
import AlgoliaSearch

struct SearchParamsEncoder {
  static func encode(_ params: SearchSearchParamsObject) -> String? {
    guard let dictionary = params.asDictionary else { return nil }
    let items = dictionary
      .sorted(by: { $0.key < $1.key })
      .compactMap { key, value -> String? in
        guard let encodedValue = encodeValue(value) else { return nil }
        guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        guard let encodedValueEscaped = encodedValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return "\(encodedKey)=\(encodedValueEscaped)"
      }
    return items.isEmpty ? nil : items.joined(separator: "&")
  }

  private static func encodeValue(_ value: Any) -> String? {
    switch value {
    case is NSNull:
      return nil
    case let string as String:
      return string
    case let number as NSNumber:
      return number.stringValue
    case let array as [Any]:
      return encodeJSON(array)
    case let dict as [String: Any]:
      return encodeJSON(dict)
    default:
      return String(describing: value)
    }
  }

  private static func encodeJSON(_ value: Any) -> String? {
    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else { return nil }
    return String(data: data, encoding: .utf8)
  }
}

private extension SearchSearchParamsObject {
  var asDictionary: [String: Any]? {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
  }
}

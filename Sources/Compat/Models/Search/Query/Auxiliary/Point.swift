//
//  Point.swift
//  
//
//  Created by Vladislav Fitc on 20/03/2020.
//

import Foundation

/**
 A set of geo-coordinates latitude and longitude.
 */

public struct Point: Equatable {

  public let latitude: Double
  public let longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  var stringForm: String {
    return "\(latitude),\(longitude)"
  }

}

extension Point: RawRepresentable {

  public var rawValue: [Double] {
    return [latitude, longitude]
  }

  public init?(rawValue: [Double]) {
    guard rawValue.count > 1 else { return nil }
    self.init(latitude: rawValue[0], longitude: rawValue[1])
  }

}

extension Point: Codable {

  struct StringForm: Decodable {

    let point: Point

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let stringValue = try container.decode(String.self)
      let rawValue = stringValue.split(separator: ",").compactMap(Double.init)
      guard rawValue.count == 2 else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Decoded string must contain two floating point values separated by comma character")
      }
      point = .init(latitude: rawValue[0], longitude: rawValue[1])
    }

  }

  struct DictionaryForm: Decodable {

    let point: Point

    enum CodingKeys: String, CodingKey {
      case latitude = "lat"
      case longitude = "lng"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let latitude: Double = try container.decode(forKey: .latitude)
      let longitude: Double = try container.decode(forKey: .longitude)
      self.point = .init(latitude: latitude, longitude: longitude)
    }

  }

  public init(from decoder: Decoder) throws {
    if let arrayForm = try? [DictionaryForm](from: decoder) {
      guard let firstPoint = arrayForm.first else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Empty points list"))
      }
      self = firstPoint.point
    } else if let dictionaryForm = try? DictionaryForm(from: decoder) {
      self = dictionaryForm.point
    } else if let stringForm = try? StringForm(from: decoder) {
      self = stringForm.point
    } else {
      let encoded = (try? String(data: JSONEncoder().encode(JSON(from: decoder)), encoding: .utf8)) ?? ""
      let context = DecodingError.Context(codingPath: decoder.codingPath,
                                          debugDescription: "The format \(encoded) doesn't match \"22.2268,84.8463\" string or {\"lat\": 22.2268, \"lng\": 84.8463 } dictionary")
      throw DecodingError.dataCorrupted(context)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode("\(latitude),\(longitude)")
  }

}

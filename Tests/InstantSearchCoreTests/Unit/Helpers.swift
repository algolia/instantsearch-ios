import Foundation
import AlgoliaSearchClientSwift

func safeIndexName(_ name: String) -> IndexName {
  var targetName = Bundle.main.object(forInfoDictionaryKey: "BUILD_TARGET_NAME") as? String ?? ""
  targetName = targetName.replacingOccurrences(of: " ", with: "-")

  let rawName: String
  if let travisBuild = ProcessInfo.processInfo.environment["TRAVIS_JOB_NUMBER"] {
    rawName = "\(name)_travis_\(travisBuild)"
  } else if let bitriseBuild = Bundle.main.object(forInfoDictionaryKey: "BITRISE_BUILD_NUMBER") as? String {
    rawName = "\(name)_bitrise_\(bitriseBuild)_\(targetName)"
  } else {
    rawName = name
  }
  return IndexName(rawValue: rawName)
}

func average(values: [Double]) -> Double {
  return values.reduce(0, +) / Double(values.count)
}

/// Generate a new host name in the `algolia.biz` domain.
/// The DNS lookup for any host in the `algolia.biz` domain will time-out.
/// Generating a new host name every time avoids any system-level or network-level caching side effect.
///
func uniqueAlgoliaBizHost() -> String {
  return "swift-\(UInt32(NSDate().timeIntervalSince1970)).algolia.biz"
}

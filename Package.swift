// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "InstantSearch",
  platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .watchOS(.v7),
    .tvOS(.v14)
  ],
  products: [
    .library(
      name: "InstantSearch",
      targets: ["InstantSearch", "InstantSearchCore"]
    ),
    .library(
      name: "InstantSearchCore",
      targets: ["InstantSearchCore"]
    ),
    .library(
      name: "InstantSearchInsights",
      targets: ["InstantSearchInsights"]
    ),
    .library(
      name: "InstantSearchSwiftUI",
      targets: ["InstantSearchSwiftUI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/algolia/algoliasearch-client-swift",
             "9.41.0"..<"10.0.0"),
    .package(url: "https://github.com/apple/swift-log",
             from: "1.5.4"),
    .package(url: "https://github.com/apple/swift-protobuf",
             exact: "1.26.0"),
    .package(url: "https://github.com/algolia/instantsearch-telemetry-native",
             exact: "0.1.3")
  ],
  targets: [
    .target(
      name: "InstantSearchInsights",
      dependencies: [
        .product(name: "AlgoliaCore", package: "algoliasearch-client-swift"),
        .product(name: "AlgoliaInsights", package: "algoliasearch-client-swift")
      ],
      exclude: ["Readme.md"],
      resources: [.copy("../PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "InstantSearchInsightsTests",
      dependencies: [
        "InstantSearchInsights",
        .product(name: "AlgoliaCore", package: "algoliasearch-client-swift"),
        .product(name: "AlgoliaInsights", package: "algoliasearch-client-swift")
      ]
    ),
    .target(
      name: "InstantSearchCore",
      dependencies: [
        .product(name: "AlgoliaCore", package: "algoliasearch-client-swift"),
        .product(name: "AlgoliaSearch", package: "algoliasearch-client-swift"),
        "InstantSearchInsights",
        .product(name: "InstantSearchTelemetry", package: "instantsearch-telemetry-native"),
        .product(name: "Logging", package: "swift-log")
      ],
      resources: [.copy("../PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "InstantSearchCoreTests",
      dependencies: [
        "InstantSearchCore",
        "InstantSearchInsights",
        .product(name: "AlgoliaCore", package: "algoliasearch-client-swift"),
        .product(name: "AlgoliaSearch", package: "algoliasearch-client-swift")
      ],
      resources: [
        .copy("Misc/DisjFacetingResult1.json"),
        .copy("Misc/DisjFacetingResult2.json"),
        .copy("Misc/DisjFacetingResult3.json"),
        .copy("Misc/disjunctive.json"),
        .copy("Misc/disjunctiveHierarchical.json"),
        .copy("Misc/hierarchical.json"),
        .copy("Misc/SearchResultFacets.json"),
        .copy("Misc/SearchResultFacets2.json")
      ]
    ),
    .target(
      name: "InstantSearch",
      dependencies: ["InstantSearchCore"],
      resources: [.copy("../PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "InstantSearchTests",
      dependencies: ["InstantSearch"]
    ),
    .target(
      name: "InstantSearchSwiftUI",
      dependencies: ["InstantSearchCore", .product(name: "InstantSearchTelemetry", package: "instantsearch-telemetry-native")],
      resources: [.copy("../PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "InstantSearchSwiftUITests",
      dependencies: ["InstantSearchSwiftUI"]
    )
  ]
)

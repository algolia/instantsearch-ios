// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstantSearch",
    platforms: [
          .iOS(.v9),
          .macOS(.v10_10),
          .watchOS(.v2),
          .tvOS(.v9)
    ],
    products: [
        .library(
            name: "InstantSearch",
            targets: ["InstantSearch", "InstantSearchCore"]),
        .library(
            name: "InstantSearchCore",
            targets: ["InstantSearchCore"])
    ],
    dependencies: [
      .package(name: "AlgoliaSearchClient", url:"https://github.com/algolia/algoliasearch-client-swift", from: "8.0.0"),
      .package(name: "InstantSearchInsights", url:"https://github.com/algolia/instantsearch-ios-insights", from: "2.3.2")
    ],
    targets: [
        .target(
            name: "InstantSearchCore",
            dependencies: ["AlgoliaSearchClient", "InstantSearchInsights"]),
        .target(
            name: "InstantSearch",
            dependencies: ["InstantSearchCore"]),
        .testTarget(
            name: "InstantSearchCoreTests",
            dependencies: ["InstantSearchCore", "AlgoliaSearchClient", "InstantSearchInsights"]),
        .testTarget(
            name: "InstantSearchTests",
            dependencies: ["InstantSearch"])
    ]
)

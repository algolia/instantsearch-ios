// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstantSearch",
    products: [
        .library(
            name: "InstantSearch",
            targets: ["InstantSearch"]),
        .library(
            name: "InstantSearchCore",
            targets: ["InstantSearchCore"]),
    ],
    dependencies: [
      .package(name: "AlgoliaSearchClientSwift", url:"https://github.com/algolia/algoliasearch-client-swift", from: "8.0.0-beta.6"),
      .package(name: "InstantSearchInsights", url:"https://github.com/algolia/instantsearch-ios-insights", from: "2.3.2"),
    ],
    targets: [
        .target(
            name: "InstantSearchCore",
            dependencies: ["AlgoliaSearchClientSwift", "InstantSearchInsights"],
            path: "Sources/InstantSearchCore"),
        .target(
            name: "InstantSearch",
            dependencies: ["InstantSearchCore"],
            path: "Sources/InstantSearch"),
        .testTarget(
            name: "InstantSearchCoreTests",
            dependencies: ["InstantSearchCore", "AlgoliaSearchClientSwift", "InstantSearchInsights"],
            path: "Tests/InstantSearchCoreTests"),
        .testTarget(
            name: "InstantSearchTests",
            dependencies: ["InstantSearch"],
            path: "Tests/InstantSearchTests"),
    ]
)

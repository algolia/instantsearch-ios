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
      targets: ["InstantSearchCore"]),
    .library(
      name: "InstantSearchInsights",
      targets: ["InstantSearchInsights"])
  ],
  dependencies: [
    .package(name: "AlgoliaSearchClient", url:"https://github.com/algolia/algoliasearch-client-swift", from: "8.5.0")
  ],
  targets: [
    .target(
      name: "InstantSearchInsights",
      dependencies: ["AlgoliaSearchClient"]),
    .target(
      name: "InstantSearchCore",
      dependencies: ["AlgoliaSearchClient", "InstantSearchInsights"]),
    .target(
      name: "InstantSearch",
      dependencies: ["InstantSearchCore"]),
    .testTarget(
      name: "InstantSearchInsightsTests",
      dependencies: ["InstantSearchInsights", "AlgoliaSearchClient"]),
    .testTarget(
      name: "InstantSearchCoreTests",
      dependencies: ["InstantSearchCore", "AlgoliaSearchClient", "InstantSearchInsights"]),
    .testTarget(
      name: "InstantSearchTests",
      dependencies: ["InstantSearch"])
  ]
)

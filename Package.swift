// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "InstantSearch",
  products: [
    .library(
      name: "InstantSearch",
      targets: ["InstantSearch", "InstantSearchCore"]),
    .library(
      name: "InstantSearchCore",
      targets: ["InstantSearchCore"]),
    .library(
      name: "InstantSearchInsights",
      targets: ["InstantSearchInsights"]),
    .library(
      name: "InstantSearchSwiftUI",
      targets: ["InstantSearchSwiftUI"])
  ],
  dependencies: [
    .package(name: "AlgoliaSearchClient",
             url: "https://github.com/algolia/algoliasearch-client-swift",
             from: "8.13.0"),
    .package(name: "InstantSearchTelemetry",
             url: "https://github.com/algolia/instantsearch-telemetry-native",
             .branch("chore/bump-dependencies"))
  ],
  targets: [
    .target(
      name: "InstantSearchInsights",
      dependencies: ["AlgoliaSearchClient"]),
    .testTarget(
      name: "InstantSearchInsightsTests",
      dependencies: ["InstantSearchInsights", "AlgoliaSearchClient"]),
    .target(
      name: "InstantSearchCore",
      dependencies: ["AlgoliaSearchClient", "InstantSearchInsights", .product(name: "InstantSearchTelemetry", package: "InstantSearchTelemetry")]),
    .testTarget(
      name: "InstantSearchCoreTests",
      dependencies: ["InstantSearchCore", "AlgoliaSearchClient", "InstantSearchInsights"]),
    .target(
      name: "InstantSearch",
      dependencies: ["InstantSearchCore"]),
    .testTarget(
      name: "InstantSearchTests",
      dependencies: ["InstantSearch"]),
    .target(
      name: "InstantSearchSwiftUI",
      dependencies: ["InstantSearchCore"]),
    .testTarget(
      name: "InstantSearchSwiftUITests",
      dependencies: ["InstantSearchSwiftUI"])

  ]
)

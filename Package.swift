// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "InstantSearch",
  platforms: [
    .iOS(.v9),
    .macOS(.v10_11),
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
             from: "0.1.2")
  ],
  targets: [
    .target(
      name: "InstantSearchInsights",
      dependencies: ["AlgoliaSearchClient"],
      exclude: ["Readme.md"]),
    .testTarget(
      name: "InstantSearchInsightsTests",
      dependencies: ["InstantSearchInsights", "AlgoliaSearchClient"]),
    .target(
      name: "InstantSearchCore",
      dependencies: ["AlgoliaSearchClient", "InstantSearchInsights", .product(name: "InstantSearchTelemetry", package: "InstantSearchTelemetry")]),
    .testTarget(
      name: "InstantSearchCoreTests",
      dependencies: ["InstantSearchCore", "AlgoliaSearchClient", "InstantSearchInsights"],
      resources: [
        .copy("Misc/DisjFacetingResult1.json"),
        .copy("Misc/DisjFacetingResult2.json"),
        .copy("Misc/DisjFacetingResult3.json"),
        .copy("Misc/disjunctive.json"),
        .copy("Misc/disjunctiveHierarchical.json"),
        .copy("Misc/hierarchical.json"),
        .copy("Misc/SearchResultFacets.json"),
        .copy("Misc/SearchResultFacets2.json")
      ]),
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

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
      targets: ["InstantSearchInsights"]),
    .library(
      name: "InstantSearchSwiftUI",
      targets: ["InstantSearchSwiftUI"])
  ],
  dependencies: [
    .package(name: "AlgoliaSearchClient",
             url: "https://github.com/algolia/algoliasearch-client-swift",
             .branch("feat/dynamic-user-agent")),
    .package(name: "SwiftProtobuf",
             url: "https://github.com/apple/swift-protobuf.git",
             from: "1.6.0"),
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
      dependencies: ["AlgoliaSearchClient", "InstantSearchInsights", "SwiftProtobuf"]),
    .testTarget(
      name: "InstantSearchCoreTests",
      dependencies: ["InstantSearchCore", "AlgoliaSearchClient", "InstantSearchInsights", "SwiftProtobuf"]),
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

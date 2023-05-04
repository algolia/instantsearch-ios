//
//  HitsList.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation
import SwiftUI

/// `HitsList` is a SwiftUI generic view responsible for displaying a list of paginated data provided by the `InfiniteScrollViewModel` class.
/// It provides an easy way to render hits as well as handling pagination and no results view.
///
/// Usage:
/// ```
/// let hits = Hits(source: CustomPageSource())
/// let hitsList = HitsList(hits, hitView: { hit in
///   Text(hit.title)
/// }, noResults: {
///   Text("No results found")
/// })
/// ```
///
/// - Note: This view is available from iOS 15.0 onwards.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct HitsList<HitView: View, NoResults: View, Item, P: Page<Item>>: View {

  /// An instance of `InfiniteScrollViewModel` object.
  @StateObject public var hits: InfiniteScrollViewModel<P>

  /// A closure that returns a `HitView` for a given `Source.Item`.
  let hit: (Item) -> HitView

  /// A closure that returns a `NoResults` view to display when there are no hits.
  let noResults: () -> NoResults

  /// Initializes a new instance of `HitsList` with the provided `hits`, `hitView` and `noResults` closures.
  ///
  /// - Parameters:
  ///   - hits: An instance of `InfiniteScrollViewModel` object.
  ///   - hitView: A closure that returns a `HitView` for a given `Source.Item`.
  ///   - noResults: A closure that returns a `NoResults` view to display when there are no hits.
  public init(_ hits: InfiniteScrollViewModel<P>,
              @ViewBuilder hitView: @escaping (Item) -> HitView,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    _hits = StateObject(wrappedValue: hits)
    hit = hitView
    self.noResults = noResults
  }

  public var body: some View {
    if hits.items.isEmpty && !hits.hasNext {
      noResults()
        .frame(maxHeight: .infinity)
    } else {
      ScrollView {
        LazyVStack {
          if hits.hasPrevious {
            ProgressView()
              .task {
                hits.loadPrevious()
              }
          }
          ForEach(0..<hits.items.count, id: \.self) { index in
            hit(hits.items[index])
          }
          if hits.hasNext {
            ProgressView()
              .task {
                hits.loadNext()
              }
          }
        }
      }
    }
  }

}

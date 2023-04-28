//
//  HitsList.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation
import SwiftUI

/// `HitsList` is a SwiftUI generic view responsible for displaying a list of paginated data provided by the `Hits` class.
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
@available(iOS 15.0, macOS 12.0, *)
public struct HitsList<HitView: View, NoResults: View, Source: PageSource>: View {
  
  /// An instance of `Hits` object.
  @StateObject public var hits: Hits<Source>
  
  /// A closure that returns a `HitView` for a given `Source.Item`.
  let hit: (Source.Item) -> HitView
  
  /// A closure that returns a `NoResults` view to display when there are no hits.
  let noResults: () -> NoResults
  
  /// Initializes a new instance of `HitsList` with the provided `hits`, `hitView` and `noResults` closures.
  ///
  /// - Parameters:
  ///   - hits: An instance of `Hits` object.
  ///   - hitView: A closure that returns a `HitView` for a given `Source.Item`.
  ///   - noResults: A closure that returns a `NoResults` view to display when there are no hits.
  public init(_ hits: Hits<Source>,
              @ViewBuilder hitView: @escaping (Source.Item) -> HitView,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    _hits = StateObject(wrappedValue: hits)
    hit = hitView
    self.noResults = noResults
  }
  
  public var body: some View {
    if hits.hits.isEmpty && !hits.hasNext {
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
          ForEach(0..<hits.hits.count, id: \.self) { index in
            hit(hits.hits[index])
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

//
//  HitsSearcher+PageSource.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension HitsSearcher {
  /// Build `InfiniteScrollViewModel` with the current `HitsSearcher` instance as `PageSource`
  func infiniteScrollViewModel<Item: Decodable>(of item: Item.Type) -> InfiniteScrollViewModel<AlgoliaHitsPage<Item>> {
    let source = HitsSearcherPageSource<Item>(hitsSearcher: self)
    let viewModel = InfiniteScrollViewModel(source: source)
    onQueryChanged.subscribe(with: viewModel) { viewModel, _ in
      Task {
        await viewModel.reset()
      }
    }
    return viewModel
  }
}

/// Wrapper for `HitsSearcher` implementing the `PageSource protocol`
@available(iOS 13, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
internal class HitsSearcherPageSource<Hit: Decodable>: PageSource {

  typealias ItemsPage = AlgoliaHitsPage<Hit>

  /// The wrapped `HitsSearcher` instance
  let hitsSearcher: HitsSearcher

  /// Initializes a new instance of `HitsSearcherPageSource` with a given `HitsSearcher` object.
  ///
  /// - Parameter hitsSearcher: The instance of `HitsSearcher`.
  init(hitsSearcher: HitsSearcher) {
    self.hitsSearcher = hitsSearcher
  }
  func fetchInitialPage() async throws -> ItemsPage {
    hitsSearcher.request.query.page = 0
    return try await getPage()
  }
  func fetchPage(before page: ItemsPage) async throws -> ItemsPage {
    hitsSearcher.request.query.page = page.page-1
    return try await getPage()
  }
  func fetchPage(after page: ItemsPage) async throws -> ItemsPage {
    hitsSearcher.request.query.page = page.page+1
    return try await getPage()
  }

  private func getPage() async throws -> ItemsPage {
    try await withCheckedThrowingContinuation { continuation in
      hitsSearcher.onResults.subscribeOnce(with: self) { _, response in
        do {
          let page = try AlgoliaHitsPage<Hit>(response)
          continuation.resume(returning: page)
        } catch let error {
          continuation.resume(throwing: error)
        }
      }
      hitsSearcher.onError.subscribeOnce(with: self) { _, error in
        continuation.resume(throwing: error)
      }
      hitsSearcher.search()
    }
  }

}

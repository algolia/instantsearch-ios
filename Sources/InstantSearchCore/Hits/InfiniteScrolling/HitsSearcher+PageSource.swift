//
//  HitsSearcher+PageSource.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public class HitsSearcherPageSource<Hit: Decodable>: PageSource {
  
  public typealias ItemsPage = AlgoliaHitsPage<Hit>
  
  public typealias Item = Hit
  
  let hitsSearcher: HitsSearcher
  
  public init(hitsSearcher: HitsSearcher) {
    self.hitsSearcher = hitsSearcher
  }
  
  public func fetchInitialPage() async throws -> ItemsPage {
    hitsSearcher.request.query.page = 0
    return try await getPage()
  }
  
  public func fetchPage(before page: ItemsPage) async throws -> ItemsPage {
    hitsSearcher.request.query.page = page.page-1
    return try await getPage()
  }
  
  public func fetchPage(after page: ItemsPage) async throws -> ItemsPage {
    hitsSearcher.request.query.page = page.page+1
    return try await getPage()
  }
   
  private func getPage() async throws -> ItemsPage {
    try await withCheckedThrowingContinuation { continuation in
      hitsSearcher.onResults.subscribeOnce(with: self) { searcher, response in
        let page = AlgoliaSearchResponse<Hit>(searchResponse: response).fetchPage()
        continuation.resume(returning: page)
      }
      hitsSearcher.onError.subscribeOnce(with: self) { searcher, error in
        continuation.resume(throwing: error)
      }
      hitsSearcher.search()
    }
  }

}


@available(iOS 13.0, *)
public extension HitsSearcher {
  
  func hitsViewModel<Item: Decodable>(of item: Item.Type) -> InfiniteScrollViewModel<AlgoliaHitsPage<Item>> {
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

//
//  IndexSegment+AnswersSearcher.swift
//  
//
//  Created by Vladislav Fitc on 15/12/2020.
//

import Foundation

@available(*, deprecated, message: "Use SortByInteractor")
public extension IndexSegment {

  struct AnswersSearcherConnection: Connection {

    let interactor: IndexSegmentInteractor
    let searcher: AnswersSearcher

    public func connect() {
      if let selected = interactor.selected, let index = interactor.items[selected] {
        searcher.request.indexName = index.name
      }

      interactor.onSelectedComputed.subscribePast(with: searcher) { [weak interactor] searcher, computed in
        if
          let selected = computed,
          let index = interactor?.items[selected]
        {
          interactor?.selected = selected
          searcher.request.indexName = index.name
          searcher.search()
        }
      }
    }

    public func disconnect() {
      interactor.onSelectedComputed.cancelSubscription(for: searcher)
    }

  }

}

@available(*, deprecated, message: "Use SortByInteractor")
public extension IndexSegmentInteractor {

  @discardableResult func connectSearcher(searcher: AnswersSearcher) -> IndexSegment.AnswersSearcherConnection {
    let connection = IndexSegment.AnswersSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}

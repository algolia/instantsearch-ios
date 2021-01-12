//
//  AnswerInteractor.swift
//  
//
//  Created by Vladislav Fitc on 04/12/2020.
//

import Foundation

public class AnswerInteractor: ItemInteractor<Answer?> {

  public override init(item: Answer? = nil) {
    super.init(item: item)
  }

}

extension AnswerInteractor {

  /// Connection between a rule custom data logic and a single index searcher
  public struct SearchResultConnection<S: SearchResultObservable>: Connection where S.SearchResult == SearchResponse {

    /// Logic applied to the custom model
    public let interactor: AnswerInteractor

    /// Searcher that handles your searches
    public let searchResultObservable: S

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searchResultObservable: SearchResultObservable implementation to connect
    */
    public init(interactor: AnswerInteractor, searchResultObservable: S) {
      self.searchResultObservable = searchResultObservable
      self.interactor = interactor
    }

    public func connect() {
      searchResultObservable.onResults.subscribe(with: interactor) { (_, _) in
      }
    }

    public func disconnect() {
      searchResultObservable.onResults.cancelSubscription(for: interactor)
    }

  }

}

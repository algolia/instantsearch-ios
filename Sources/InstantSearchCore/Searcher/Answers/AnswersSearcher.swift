//
//  AnswersSearcher.swift
//  
//
//  Created by Vladislav Fitc on 30/11/2020.
//

import Foundation

/// An entity performing Answers search
///
/// [Documentation](https://www.algolia.com/doc/guides/algolia-ai/answers/)
@available(*, deprecated, message: "Answers feature is deprecated")
public final class AnswersSearcher: IndexSearcher<AlgoliaAnswersSearchService> {

  public override var request: Request {
    didSet {
      guard request.query.query != oldValue.query.query || request.indexName != oldValue.indexName else { return }
      request.query.page = 0
    }
  }

  /**
   - Parameters:
      - applicationID: Application ID
      - apiKey: API Key
      - indexName: Name of the index in which search will be performed
      - query: Instance of AnswersQuery. By default a new empty instant of Query will be created.
      - requestOptions: Custom request options. Default is `nil`.
  */
  public convenience init(applicationID: ApplicationID,
                          apiKey: APIKey,
                          indexName: IndexName,
                          query: AnswersQuery = .init(query: "", queryLanguages: [.english]),
                          requestOptions: RequestOptions? = nil) {
    let service = AlgoliaAnswersSearchService(client: .init(appID: applicationID,
                                                            apiKey: apiKey))
    let request = Request(indexName: indexName,
                          query: query,
                          requestOptions: requestOptions)
    self.init(service: service, initialRequest: request)
    Telemetry.shared.trace(type: .answersSearcher)
  }

}

@available(*, deprecated, message: "Answers feature is deprecated")
extension AnswersSearcher: IndexNameSettable {

  public func setIndexName(_ indexName: IndexName) {
    request.indexName = indexName
  }

}

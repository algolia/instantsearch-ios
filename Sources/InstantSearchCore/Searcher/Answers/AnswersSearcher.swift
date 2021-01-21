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
public final class AnswersSearcher: IndexSearcher<AlgoliaAnswersSearchService> {

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
  }

}

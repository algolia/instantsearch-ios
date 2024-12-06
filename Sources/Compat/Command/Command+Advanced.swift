//
//  Command+Advanced.swift
//  
//
//  Created by Vladislav Fitc on 10.03.2020.
//

import Foundation

extension Command {

  enum Advanced {

    struct TaskStatus: AlgoliaCommand {

      let method: HTTPMethod = .get
      let callType: CallType = .read
      let path: URL
      let requestOptions: RequestOptions?

      init(indexName: IndexName, taskID: TaskID, requestOptions: RequestOptions?) {
        self.requestOptions = requestOptions
        self.path = URL
          .indexesV1
          .appending(indexName)
          .appending(.task)
          .appending(taskID)
      }

    }

    struct AppTaskStatus: AlgoliaCommand {

      let method: HTTPMethod = .get
      let callType: CallType = .read
      let path: URL
      let requestOptions: RequestOptions?

      init(taskID: AppTaskID, requestOptions: RequestOptions?) {
        self.requestOptions = requestOptions
        self.path = URL
          .task
          .appending(taskID)
      }

    }

    struct GetLogs: AlgoliaCommand {

      let method: HTTPMethod = .get
      let callType: CallType = .read
      let path = URL.logs
      let requestOptions: RequestOptions?

      init(indexName: IndexName?, offset: Int?, length: Int?, logType: LogType, requestOptions: RequestOptions?) {
        let requestOptions = requestOptions.updateOrCreate(
          [:]
            .merging(indexName.flatMap { [.indexName: $0.rawValue] } ?? [:])
            .merging(offset.flatMap { [.offset: String($0)] } ?? [:])
            .merging(length.flatMap { [.length: String($0)] } ?? [:])
            .merging([.type: logType.rawValue])
        )
        self.requestOptions = requestOptions
      }

    }

  }

}

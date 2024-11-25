//
//  Transport.swift
//
//
//  Created by Vladislav Fitc on 03/03/2020.
//

import Core
import Foundation

protocol Transport: Credentials {

  func execute<Command: AlgoliaCommand, Response: Decodable, Output>(_ command: Command, transform: @escaping (Response) -> Output, completion: @escaping (Result<Output, Error>) -> Void) -> Operation & TransportTask
  func execute<Command: AlgoliaCommand, Response: Decodable, Output>(_ command: Command, transform: @escaping (Response) -> Output) throws -> Output

}

extension Transport {

  func execute<Command: AlgoliaCommand, Output: Decodable>(_ command: Command, completion: @escaping ResultCallback<Output>) -> Operation & TransportTask {
    execute(command, transform: { $0 }, completion: completion)
  }

  func execute<Command: AlgoliaCommand, Output: Decodable>(_ command: Command) throws -> Output {
    try execute(command, transform: { $0 })
  }

}

public typealias TransportTask = Cancellable & ProgressReporting

//
//  TransportContainer.swift
//  
//
//  Created by Vladislav Fitc on 02/06/2020.
//

import Core
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol TransportContainer {

  var transport: Transport { get }

}

extension TransportContainer {

  func execute<Command: AlgoliaCommand, Response: Decodable, Output>(_ command: Command,
                                                                     transform: @escaping (Response) -> Output,
                                                                     completion: @escaping (Result<Output, Error>) -> Void) -> Operation & TransportTask {
    transport.execute(command, transform: transform, completion: completion)
  }

  func execute<Command: AlgoliaCommand, Response: Decodable, Output>(_ command: Command,
                                                                     transform: @escaping (Response) -> Output) throws -> Output {
    try transport.execute(command, transform: transform)
  }

}

extension TransportContainer {

  @discardableResult func customRequest<T: Decodable>(callType: CallType,
                                                      request: URLRequest,
                                                      requestOptions: RequestOptions? = nil,
                                                      completion: @escaping ResultCallback<T>) -> Operation {
    transport.customRequest(callType: callType, request: request, requestOptions: requestOptions, completion: completion)
  }

  @discardableResult func customRequest<T: Decodable>(callType: CallType,
                                                      request: URLRequest,
                                                      requestOptions: RequestOptions? = nil) throws -> T {
    try transport.customRequest(callType: callType, request: request, requestOptions: requestOptions)
  }

}

extension TransportContainer {

  @discardableResult func execute<Command: AlgoliaCommand, Output: Decodable>(_ command: Command, completion: @escaping ResultCallback<Output>) -> Operation & TransportTask {
    execute(command, transform: { $0 }, completion: completion)
  }

  @discardableResult func execute<Command: AlgoliaCommand, Output: Decodable>(_ command: Command) throws -> Output {
    try execute(command, transform: { $0 })
  }

}

extension TransportContainer where Self: Credentials {

  func execute<Command: AlgoliaCommand, Output: Decodable & IndexTask & IndexNameContainer>(_ command: Command, completion: @escaping ResultTaskCallback<Output>) -> Operation & TransportTask {
    transport.execute(command, transform: WaitableWrapper.wrap(credentials: self), completion: completion)
  }

  func execute<Command: AlgoliaCommand, Output: Decodable & IndexTask & IndexNameContainer>(_ command: Command) throws -> WaitableWrapper<Output> {
    try transport.execute(command, transform: WaitableWrapper.wrap(credentials: self))
  }

}

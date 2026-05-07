//
//  UIMessageChunk.swift
//  InstantSearchAgentStudio
//
//  AI SDK 5 streaming chunks. One JSON object per `data:` line in the SSE
//  response. Mirror of `UIMessageChunk` from
//  `instantsearch.js/src/lib/ai-lite/types.ts`.
//

import Foundation

/// One frame parsed from the SSE stream.
///
/// We model the closed set of chunks we currently aggregate, plus a
/// `case unknown(Data)` fallback so backend additions don't break parsing.
public enum UIMessageChunk: Sendable, Equatable {
  // Lifecycle
  case start(messageId: String?)
  case startStep
  case finishStep
  case finish
  case abort

  // Streaming text
  case textStart(id: String)
  case textDelta(id: String, delta: String)
  case textEnd(id: String)

  // Streaming reasoning
  case reasoningStart(id: String)
  case reasoningDelta(id: String, delta: String)
  case reasoningEnd(id: String)

  // Tools (AI SDK 5 names)
  case toolInputStart(toolName: String, toolCallId: String)
  case toolInputDelta(toolName: String, toolCallId: String, inputTextDelta: String)
  case toolInputAvailable(toolName: String, toolCallId: String, input: Data)
  case toolOutputAvailable(toolName: String, toolCallId: String, output: Data, preliminary: Bool)
  case toolError(toolName: String, toolCallId: String, errorText: String, input: Data?)

  // Sources / files
  case sourceURL(sourceId: String, url: URL, title: String?)
  case file(url: URL, mediaType: String)

  // Custom data-<name> chunks
  case data(name: String, id: String?, json: Data)

  // Errors
  case error(errorText: String)

  // Anything we don't yet model
  case unknown(typeIdentifier: String, json: Data)
}

extension UIMessageChunk {
  /// Decode a single SSE payload (the JSON after `data:`).
  ///
  /// Returns `nil` for the SSE termination sentinel (`[DONE]`). Throws if the
  /// payload is not valid JSON or doesn't contain a `type` field.
  static func decode(payload: Data) throws -> UIMessageChunk? {
    guard let raw = try JSONSerialization.jsonObject(with: payload, options: []) as? [String: Any] else {
      throw AgentStudioError.malformedChunk
    }
    guard let type = raw["type"] as? String else {
      throw AgentStudioError.malformedChunk
    }

    func subdata(_ key: String) -> Data? {
      guard let value = raw[key] else { return nil }
      return try? JSONSerialization.data(withJSONObject: value, options: [])
    }
    func string(_ key: String) -> String? { raw[key] as? String }
    func bool(_ key: String) -> Bool? { raw[key] as? Bool }

    switch type {
    case "start":
      return .start(messageId: string("messageId"))
    case "start-step":
      return .startStep
    case "finish-step":
      return .finishStep
    case "finish":
      return .finish
    case "abort":
      return .abort
    case "text-start":
      guard let id = string("id") else { throw AgentStudioError.malformedChunk }
      return .textStart(id: id)
    case "text-delta":
      guard let id = string("id"), let delta = string("delta") else { throw AgentStudioError.malformedChunk }
      return .textDelta(id: id, delta: delta)
    case "text-end":
      guard let id = string("id") else { throw AgentStudioError.malformedChunk }
      return .textEnd(id: id)
    case "reasoning-start":
      guard let id = string("id") else { throw AgentStudioError.malformedChunk }
      return .reasoningStart(id: id)
    case "reasoning-delta":
      guard let id = string("id"), let delta = string("delta") else { throw AgentStudioError.malformedChunk }
      return .reasoningDelta(id: id, delta: delta)
    case "reasoning-end":
      guard let id = string("id") else { throw AgentStudioError.malformedChunk }
      return .reasoningEnd(id: id)
    case "tool-input-start":
      guard let name = string("toolName"), let cid = string("toolCallId") else { throw AgentStudioError.malformedChunk }
      return .toolInputStart(toolName: name, toolCallId: cid)
    case "tool-input-delta":
      guard let name = string("toolName"), let cid = string("toolCallId"),
            let delta = string("inputTextDelta") else { throw AgentStudioError.malformedChunk }
      return .toolInputDelta(toolName: name, toolCallId: cid, inputTextDelta: delta)
    case "tool-input-available":
      guard let name = string("toolName"), let cid = string("toolCallId"),
            let input = subdata("input") else { throw AgentStudioError.malformedChunk }
      return .toolInputAvailable(toolName: name, toolCallId: cid, input: input)
    case "tool-output-available":
      guard let name = string("toolName"), let cid = string("toolCallId"),
            let output = subdata("output") else { throw AgentStudioError.malformedChunk }
      return .toolOutputAvailable(toolName: name, toolCallId: cid, output: output,
                                   preliminary: bool("preliminary") ?? false)
    case "tool-error":
      guard let name = string("toolName"), let cid = string("toolCallId"),
            let err = string("errorText") else { throw AgentStudioError.malformedChunk }
      return .toolError(toolName: name, toolCallId: cid, errorText: err, input: subdata("input"))
    case "source-url":
      guard let sid = string("sourceId"), let urlStr = string("url"), let url = URL(string: urlStr) else {
        throw AgentStudioError.malformedChunk
      }
      return .sourceURL(sourceId: sid, url: url, title: string("title"))
    case "file":
      guard let urlStr = string("url"), let url = URL(string: urlStr),
            let media = string("mediaType") else { throw AgentStudioError.malformedChunk }
      return .file(url: url, mediaType: media)
    case "error":
      return .error(errorText: string("errorText") ?? "Unknown error")
    default:
      if type.hasPrefix("data-") {
        let name = String(type.dropFirst("data-".count))
        let payloadJson = subdata("data") ?? Data("null".utf8)
        return .data(name: name, id: string("id"), json: payloadJson)
      }
      return .unknown(typeIdentifier: type, json: payload)
    }
  }
}

/// Errors surfaced by the agent studio client.
public enum AgentStudioError: Error, Sendable, Equatable {
  case malformedChunk
  case http(status: Int, body: String?)
  case missingCredentials
  case streamClosed
  case underlying(String)
}

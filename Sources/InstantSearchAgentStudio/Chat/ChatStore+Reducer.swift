//
//  ChatStore+Reducer.swift
//  InstantSearchAgentStudio
//
//  Reduces a `UIMessageChunk` onto an existing assistant `UIMessage`.
//
//  This is the native equivalent of the chunk-handling switch inside
//  `AbstractChat.processStreamChunk` in `instantsearch.js/src/lib/ai-lite/abstract-chat.ts`.
//

import Foundation

enum ChunkReducer {
  /// Apply `chunk` to `message` in place. Returns whether the chunk produced a
  /// visible change (used to debounce UI updates).
  @discardableResult
  static func apply(_ chunk: UIMessageChunk, to message: inout UIMessage<EmptyMetadata>) -> Bool {
    switch chunk {
    case .start:
      return false

    case .startStep:
      message.parts.append(.stepStart)
      return true

    case .finishStep, .finish, .abort:
      // Mark any still-streaming text/reasoning as done.
      message.parts = message.parts.map { part in
        switch part {
        case let .text(id, text, .streaming):
          return .text(id: id, text: text, state: .done)
        case let .reasoning(id, text, .streaming):
          return .reasoning(id: id, text: text, state: .done)
        default:
          return part
        }
      }
      return true

    case let .textStart(id):
      message.parts.append(.text(id: id, text: "", state: .streaming))
      return true

    case let .textDelta(id, delta):
      if let index = lastTextIndex(in: message, withId: id) {
        if case let .text(partId, current, _) = message.parts[index] {
          message.parts[index] = .text(id: partId, text: current + delta, state: .streaming)
          return true
        }
      } else {
        message.parts.append(.text(id: id, text: delta, state: .streaming))
        return true
      }
      return false

    case let .textEnd(id):
      if let index = lastTextIndex(in: message, withId: id),
         case let .text(partId, text, _) = message.parts[index] {
        message.parts[index] = .text(id: partId, text: text, state: .done)
        return true
      }
      return false

    case let .reasoningStart(id):
      message.parts.append(.reasoning(id: id, text: "", state: .streaming))
      return true

    case let .reasoningDelta(id, delta):
      if let index = lastReasoningIndex(in: message, withId: id),
         case let .reasoning(partId, current, _) = message.parts[index] {
        message.parts[index] = .reasoning(id: partId, text: current + delta, state: .streaming)
        return true
      } else {
        message.parts.append(.reasoning(id: id, text: delta, state: .streaming))
        return true
      }

    case let .reasoningEnd(id):
      if let index = lastReasoningIndex(in: message, withId: id),
         case let .reasoning(partId, text, _) = message.parts[index] {
        message.parts[index] = .reasoning(id: partId, text: text, state: .done)
        return true
      }
      return false

    case let .toolInputStart(name, cid):
      upsertTool(in: &message, toolCallId: cid) {
        ToolUIPart(toolName: name, toolCallId: cid, state: .inputStreaming(partial: nil))
      } update: { existing in
        existing.state = .inputStreaming(partial: nil)
      }
      return true

    case let .toolInputDelta(name, cid, _):
      // We don't reconstruct the partial JSON in v0.1 — the JS lib does this
      // to support `streamInput` tools, which we'll add in v0.2.
      upsertTool(in: &message, toolCallId: cid) {
        ToolUIPart(toolName: name, toolCallId: cid, state: .inputStreaming(partial: nil))
      } update: { _ in }
      return false

    case let .toolInputAvailable(name, cid, input):
      upsertTool(in: &message, toolCallId: cid) {
        ToolUIPart(toolName: name, toolCallId: cid, state: .inputAvailable(input: input))
      } update: { existing in
        existing.state = .inputAvailable(input: input)
      }
      return true

    case let .toolOutputAvailable(name, cid, output, preliminary):
      upsertTool(in: &message, toolCallId: cid) {
        ToolUIPart(toolName: name, toolCallId: cid,
                   state: .outputAvailable(input: Data("null".utf8), output: output, preliminary: preliminary))
      } update: { existing in
        let input: Data = {
          if case let .inputAvailable(input) = existing.state { return input }
          if case let .outputAvailable(input, _, _) = existing.state { return input }
          return Data("null".utf8)
        }()
        existing.state = .outputAvailable(input: input, output: output, preliminary: preliminary)
      }
      return true

    case let .toolError(name, cid, errorText, input):
      upsertTool(in: &message, toolCallId: cid) {
        ToolUIPart(toolName: name, toolCallId: cid, state: .outputError(input: input, errorText: errorText))
      } update: { existing in
        existing.state = .outputError(input: input, errorText: errorText)
      }
      return true

    case let .sourceURL(sid, url, title):
      message.parts.append(.sourceURL(sourceId: sid, url: url, title: title))
      return true

    case let .file(url, mediaType):
      message.parts.append(.file(mediaType: mediaType, url: url, filename: nil))
      return true

    case let .data(name, id, json):
      message.parts.append(.data(name: name, id: id, json: json))
      return true

    case .error:
      // Surfaced through ChatStore.error, not as a part.
      return false

    case let .unknown(typeIdentifier, json):
      message.parts.append(.unknown(typeIdentifier: typeIdentifier, json: json))
      return false
    }
  }

  // MARK: - helpers

  private static func lastTextIndex(in message: UIMessage<EmptyMetadata>, withId id: String) -> Int? {
    for index in stride(from: message.parts.count - 1, through: 0, by: -1) {
      if case let .text(partId, _, _) = message.parts[index], partId == id {
        return index
      }
    }
    return nil
  }

  private static func lastReasoningIndex(in message: UIMessage<EmptyMetadata>, withId id: String) -> Int? {
    for index in stride(from: message.parts.count - 1, through: 0, by: -1) {
      if case let .reasoning(partId, _, _) = message.parts[index], partId == id {
        return index
      }
    }
    return nil
  }

  private static func upsertTool(
    in message: inout UIMessage<EmptyMetadata>,
    toolCallId: String,
    insert: () -> ToolUIPart,
    update: (inout ToolUIPart) -> Void
  ) {
    for index in 0..<message.parts.count {
      if case var .tool(part) = message.parts[index], part.toolCallId == toolCallId {
        update(&part)
        message.parts[index] = .tool(part)
        return
      }
    }
    message.parts.append(.tool(insert()))
  }
}

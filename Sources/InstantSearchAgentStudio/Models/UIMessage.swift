//
//  UIMessage.swift
//  InstantSearchAgentStudio
//
//  Native counterpart of the AI SDK 5 `UIMessage` shape used by
//  `instantsearch.js/src/lib/ai-lite/types.ts`.
//

import Foundation

/// Role of a message in an Agent Studio conversation.
public enum MessageRole: String, Codable, Sendable {
  case system
  case user
  case assistant
}

/// State of a streaming part (text, reasoning, …) inside a message.
public enum PartState: String, Codable, Sendable {
  case streaming
  case done
}

/// A single part of an assembled `UIMessage`.
///
/// Mirrors the `UIMessagePart` discriminated union in
/// `instantsearch-ui-components/src/components/chat/types.ts`. We model it as
/// a Swift enum with a `case unknown` fallback so newly-introduced variants
/// don't crash old clients.
public enum UIMessagePart: Sendable, Equatable {
  case text(id: String?, text: String, state: PartState?)
  case reasoning(id: String?, text: String, state: PartState?)
  case sourceURL(sourceId: String, url: URL, title: String?)
  case file(mediaType: String, url: URL, filename: String?)
  case stepStart
  /// A tool invocation, keyed by `toolCallId`.
  case tool(ToolUIPart)
  /// A custom `data-<name>` part. The payload is kept as raw JSON so callers
  /// can decode it into their own type.
  case data(name: String, id: String?, json: Data)
  /// Forward-compat fallback for chunk types we don't know yet.
  case unknown(typeIdentifier: String, json: Data)
}

/// Lifecycle of a tool call as it transitions through the AI SDK 5
/// `tool-input-*` / `tool-output-*` chunks.
public enum ToolCallState: Sendable, Equatable {
  case inputStreaming(partial: Data?)
  case inputAvailable(input: Data)
  case outputAvailable(input: Data, output: Data, preliminary: Bool)
  case outputError(input: Data?, errorText: String)
}

/// A single tool invocation embedded in an assistant message.
public struct ToolUIPart: Sendable, Equatable {
  public let toolName: String
  public let toolCallId: String
  public var state: ToolCallState

  public init(toolName: String, toolCallId: String, state: ToolCallState) {
    self.toolName = toolName
    self.toolCallId = toolCallId
    self.state = state
  }
}

/// An assembled message ready to be rendered by the host app.
///
/// `Metadata` mirrors the generic `METADATA` parameter of the JS `UIMessage`
/// — pass `EmptyMetadata` if your agent doesn't return any.
public struct UIMessage<Metadata: Codable & Sendable>: Sendable, Identifiable {
  public let id: String
  public let role: MessageRole
  public var parts: [UIMessagePart]
  public var metadata: Metadata?

  public init(id: String, role: MessageRole, parts: [UIMessagePart] = [], metadata: Metadata? = nil) {
    self.id = id
    self.role = role
    self.parts = parts
    self.metadata = metadata
  }
}

/// Default `Metadata` placeholder when the host app doesn't care about it.
public struct EmptyMetadata: Codable, Sendable, Equatable {
  public init() {}
}

// MARK: - Convenience

public extension UIMessage {
  /// Concatenated text from every `.text` part (streaming or done). Useful for
  /// quickly rendering an assistant response without walking the parts array.
  var plainText: String {
    parts.reduce(into: "") { acc, part in
      if case let .text(_, text, _) = part {
        acc += text
      }
    }
  }
}

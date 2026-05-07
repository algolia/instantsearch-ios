//
//  ChatStore.swift
//  InstantSearchAgentStudio
//
//  Native counterpart of the JS `Chat` class
//  (`instantsearch.js/src/lib/chat/chat.ts`). Aggregates streamed
//  `UIMessageChunk`s into a list of `UIMessage<EmptyMetadata>` and exposes the
//  result as `@Published` so SwiftUI views can observe it.
//

import Foundation
#if canImport(Combine)
  import Combine
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@MainActor
public final class ChatStore: ObservableObject {
  // MARK: - Published state

  @Published public private(set) var messages: [UIMessage<EmptyMetadata>] = []
  @Published public private(set) var status: ChatStatus = .ready
  @Published public private(set) var error: AgentStudioError?

  // MARK: - Configuration

  public let conversationID: String
  private let transport: AgentStudioTransport
  private let idGenerator: () -> String

  // MARK: - Internal state

  private var streamingTask: Task<Void, Never>?
  private var assistantMessageIndex: Int?

  // MARK: - Init

  /// - Parameters:
  ///   - transport: configured `AgentStudioTransport`. The simplest way to
  ///     build one is `AgentStudioTransport(endpoint:apiKey:)` with credentials
  ///     pulled from your existing Algolia `SearchClient`.
  ///   - conversationID: pass a stable id (prefixed `alg_cnv_` per Algolia
  ///     conventions) to enable server-side conversation persistence; pass
  ///     `nil` to let the store generate one.
  ///   - initialMessages: messages to restore at startup (e.g. from your own
  ///     persistence layer). Pass `[]` for a fresh chat.
  ///   - idGenerator: pluggable id factory. Defaults to UUID.
  public init(
    transport: AgentStudioTransport,
    conversationID: String? = nil,
    initialMessages: [UIMessage<EmptyMetadata>] = [],
    idGenerator: @escaping () -> String = { "alg_msg_" + UUID().uuidString }
  ) {
    self.transport = transport
    self.conversationID = conversationID ?? "alg_cnv_" + UUID().uuidString
    self.idGenerator = idGenerator
    self.messages = initialMessages
  }

  // MARK: - Public API

  /// Send a user text message and start streaming the assistant response.
  /// If a request is already in flight it is cancelled and replaced.
  public func send(text: String) {
    let userMessage = UIMessage<EmptyMetadata>(
      id: idGenerator(),
      role: .user,
      parts: [.text(id: nil, text: text, state: .done)]
    )
    messages.append(userMessage)
    startStream(trigger: .submitMessage)
  }

  /// Re-issue the last user message, replacing the trailing assistant message
  /// (if any).
  public func regenerate() {
    guard let last = messages.last else { return }
    if last.role == .assistant {
      messages.removeLast()
    }
    startStream(trigger: .regenerateMessage)
  }

  /// Cancel any in-flight streaming request. Status returns to `.ready`.
  public func stop() {
    streamingTask?.cancel()
    streamingTask = nil
    assistantMessageIndex = nil
    if status != .error {
      status = .ready
    }
  }

  /// Wipe local conversation state. Does not call any server endpoint.
  public func clear() {
    stop()
    messages = []
    error = nil
    status = .ready
  }

  /// Clears any error state without touching the messages.
  public func clearError() {
    error = nil
    if status == .error {
      status = .ready
    }
  }

  // MARK: - Streaming

  private func startStream(trigger: AgentStudioRequest.Trigger) {
    streamingTask?.cancel()
    error = nil
    status = .submitted
    assistantMessageIndex = nil

    let wireMessages: [AgentStudioRequest.WireMessage] = messages.compactMap { msg in
      let text = msg.plainText
      guard !text.isEmpty else { return nil }
      return AgentStudioRequest.WireMessage(id: msg.id, role: msg.role, text: text)
    }

    let request = AgentStudioRequest(
      conversationID: conversationID,
      messages: wireMessages,
      trigger: trigger
    )

    let conversationID = self.conversationID
    let idGenerator = self.idGenerator

    streamingTask = Task { [weak self] in
      guard let self else { return }
      do {
        let stream = try await self.transport.sendMessages(request)
        for try await chunk in stream {
          if Task.isCancelled { break }
          await self.handle(chunk: chunk, conversationID: conversationID, idGenerator: idGenerator)
        }
        if !Task.isCancelled {
          self.status = .ready
        }
      } catch {
        if Task.isCancelled { return }
        self.status = .error
        self.error = (error as? AgentStudioError) ?? .underlying(String(describing: error))
      }
    }
  }

  private func handle(chunk: UIMessageChunk,
                      conversationID: String,
                      idGenerator: () -> String) async {
    switch chunk {
    case let .start(messageId):
      let id = messageId ?? idGenerator()
      let assistant = UIMessage<EmptyMetadata>(id: id, role: .assistant)
      messages.append(assistant)
      assistantMessageIndex = messages.count - 1
      status = .streaming
    case let .error(text):
      status = .error
      error = .underlying(text)
    default:
      ensureAssistantMessage(idGenerator: idGenerator)
      guard let index = assistantMessageIndex else { return }
      var msg = messages[index]
      ChunkReducer.apply(chunk, to: &msg)
      messages[index] = msg
      if status == .submitted { status = .streaming }
    }
  }

  private func ensureAssistantMessage(idGenerator: () -> String) {
    if assistantMessageIndex == nil {
      let assistant = UIMessage<EmptyMetadata>(id: idGenerator(), role: .assistant)
      messages.append(assistant)
      assistantMessageIndex = messages.count - 1
    }
  }
}

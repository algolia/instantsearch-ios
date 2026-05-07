//
//  AgentStudioTransport.swift
//  InstantSearchAgentStudio
//
//  Thin HTTP transport over `URLSession`. Sends the AI SDK 5 completions
//  request body and exposes the parsed SSE chunk stream as an `AsyncSequence`.
//
//  Mirrors `DefaultChatTransport` from `instantsearch.js/src/lib/ai-lite/transport.ts`.
//

import Foundation

/// What we send in the request body. Kept intentionally minimal for v0.1; the
/// `extra` dictionary lets callers pass through any additional top-level
/// fields the backend supports (e.g. `algolia.searchParameters`).
public struct AgentStudioRequest: Sendable {
  public let conversationID: String?
  public let messages: [WireMessage]
  public let trigger: Trigger
  public let extra: [String: AnyEncodable]

  public init(conversationID: String?,
              messages: [WireMessage],
              trigger: Trigger = .submitMessage,
              extra: [String: AnyEncodable] = [:]) {
    self.conversationID = conversationID
    self.messages = messages
    self.trigger = trigger
    self.extra = extra
  }

  public enum Trigger: String, Sendable, Codable {
    case submitMessage = "submit-message"
    case regenerateMessage = "regenerate-message"
  }

  /// On-the-wire shape of a message. We don't reuse `UIMessage<Metadata>`
  /// directly because the wire format has a fixed shape (`text`-only parts on
  /// the user side) and we want to avoid generic propagation through the
  /// transport.
  public struct WireMessage: Sendable, Codable {
    public let id: String
    public let role: MessageRole
    public let parts: [TextPart]

    public init(id: String, role: MessageRole, text: String) {
      self.id = id
      self.role = role
      self.parts = [TextPart(text: text)]
    }
  }

  public struct TextPart: Sendable, Codable {
    public let type: String
    public let text: String
    public init(text: String) { self.type = "text"; self.text = text }
  }
}

/// Type-erased `Encodable` for the `extra` bag.
public struct AnyEncodable: Encodable, @unchecked Sendable {
  private let _encode: (Encoder) throws -> Void
  public init<T: Encodable>(_ value: T) {
    self._encode = value.encode
  }
  public func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

/// HTTP transport for the Agent Studio completions endpoint.
public final class AgentStudioTransport: @unchecked Sendable {
  public let endpoint: AgentStudioEndpoint
  private let apiKey: String
  private let userAgent: String?
  private let session: URLSession

  public init(endpoint: AgentStudioEndpoint,
              apiKey: String,
              userAgent: String? = nil,
              session: URLSession = .shared) {
    self.endpoint = endpoint
    self.apiKey = apiKey
    self.userAgent = userAgent
    self.session = session
  }

  /// Send a completion request and return an async sequence of streamed chunks.
  ///
  /// The returned `AsyncStream` finishes when the server emits the SSE
  /// `[DONE]` sentinel, when the underlying URL session task ends, or when the
  /// caller cancels its enclosing `Task`.
  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  public func sendMessages(_ request: AgentStudioRequest) async throws -> SSEStreamParser {
    let url = endpoint.completionsURL(
      stream: true,
      cache: request.trigger != .regenerateMessage
    )
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("text/event-stream", forHTTPHeaderField: "Accept")
    urlRequest.setValue(endpoint.appID, forHTTPHeaderField: "x-algolia-application-id")
    urlRequest.setValue(apiKey, forHTTPHeaderField: "x-algolia-api-key")
    if let userAgent {
      urlRequest.setValue(userAgent, forHTTPHeaderField: "x-algolia-agent")
    }
    urlRequest.httpBody = try Self.encodeBody(request)

    let (bytes, response) = try await session.bytes(for: urlRequest)

    guard let http = response as? HTTPURLResponse else {
      throw AgentStudioError.underlying("Non-HTTP response")
    }
    guard (200..<300).contains(http.statusCode) else {
      throw AgentStudioError.http(status: http.statusCode, body: nil)
    }

    return SSEStreamParser(bytes: bytes)
  }

  static func encodeBody(_ request: AgentStudioRequest) throws -> Data {
    var dict: [String: Any] = [
      "messages": try request.messages.map { try Self.encodeJSON($0) as Any },
      "trigger": request.trigger.rawValue,
    ]
    if let id = request.conversationID {
      dict["id"] = id
    }
    for (key, value) in request.extra {
      dict[key] = try Self.encodeJSON(value)
    }
    return try JSONSerialization.data(withJSONObject: dict, options: [])
  }

  private static func encodeJSON<T: Encodable>(_ value: T) throws -> Any {
    let data = try JSONEncoder().encode(value)
    return try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
  }
}

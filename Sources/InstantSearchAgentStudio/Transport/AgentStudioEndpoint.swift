//
//  AgentStudioEndpoint.swift
//  InstantSearchAgentStudio
//

import Foundation

/// Builds the Agent Studio completions URL for a given Algolia application
/// and agent. The shape is the one consumed by
/// `connectChat` in `instantsearch.js`:
///
///     https://{appId}.algolia.net/agent-studio/1/agents/{agentId}/completions
///
/// We always request `compatibilityMode=ai-sdk-5`. Streaming is opt-in through
/// `stream=true` (the default for `ChatStore`).
public struct AgentStudioEndpoint: Sendable, Equatable {
  public let appID: String
  public let agentID: String
  public let host: String

  public init(appID: String, agentID: String, host: String? = nil) {
    self.appID = appID
    self.agentID = agentID
    self.host = host ?? "\(appID).algolia.net"
  }

  /// - Parameters:
  ///   - stream: when `true`, the server streams chunks as SSE.
  ///   - cache: when `false`, bypasses any server-side cache (used by
  ///     `regenerate-message`).
  public func completionsURL(stream: Bool = true, cache: Bool = true) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = "/agent-studio/1/agents/\(agentID)/completions"
    var query = [
      URLQueryItem(name: "compatibilityMode", value: "ai-sdk-5"),
      URLQueryItem(name: "stream", value: stream ? "true" : "false"),
    ]
    if !cache {
      query.append(URLQueryItem(name: "cache", value: "false"))
    }
    components.queryItems = query
    guard let url = components.url else {
      preconditionFailure("Failed to assemble Agent Studio completions URL")
    }
    return url
  }
}

//
//  SearchClient+AgentStudio.swift
//  InstantSearchAgentStudio
//
//  Convenience constructor that builds an `AgentStudioTransport` from your
//  existing Algolia application credentials. Accepts raw strings to stay
//  independent of any specific Algolia client version — pass them from
//  whatever `SearchClient`/`Configuration` you already have:
//
//      let transport = AgentStudioTransport(
//          appID: searchClient.applicationID.rawValue,
//          apiKey: searchClient.apiKey.rawValue,
//          agentID: "my-agent")
//

import Foundation

public extension AgentStudioTransport {
  /// Build a transport for `agentID` using application-level credentials.
  ///
  /// - Important: use a **search-only** API key. Never embed admin keys in a
  ///   shipping app.
  convenience init(appID: String,
                   apiKey: String,
                   agentID: String,
                   userAgent: String? = nil,
                   session: URLSession = .shared) {
    self.init(
      endpoint: AgentStudioEndpoint(appID: appID, agentID: agentID),
      apiKey: apiKey,
      userAgent: userAgent,
      session: session
    )
  }
}

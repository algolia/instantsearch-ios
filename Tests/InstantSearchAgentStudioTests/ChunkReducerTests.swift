//
//  ChunkReducerTests.swift
//  InstantSearchAgentStudioTests
//

import XCTest
@testable import InstantSearchAgentStudio

final class ChunkReducerTests: XCTestCase {
  func testTextStreamProducesConcatenatedPart() {
    var msg = UIMessage<EmptyMetadata>(id: "alg_msg_1", role: .assistant)
    let chunks: [UIMessageChunk] = [
      .startStep,
      .textStart(id: "t-1"),
      .textDelta(id: "t-1", delta: "Hello "),
      .textDelta(id: "t-1", delta: "world"),
      .textEnd(id: "t-1"),
      .finishStep,
      .finish,
    ]
    for chunk in chunks {
      ChunkReducer.apply(chunk, to: &msg)
    }
    XCTAssertEqual(msg.plainText, "Hello world")
    if case let .text(_, _, state) = msg.parts.first(where: { if case .text = $0 { return true }; return false }) {
      XCTAssertEqual(state, .done)
    } else {
      XCTFail("expected a text part")
    }
  }

  func testToolLifecycleEndsWithOutputAvailable() throws {
    var msg = UIMessage<EmptyMetadata>(id: "alg_msg_2", role: .assistant)
    let inputJson = Data(#"{"query":"red shoes"}"#.utf8)
    let outputJson = Data(#"{"hits":[]}"#.utf8)
    let chunks: [UIMessageChunk] = [
      .toolInputStart(toolName: "algolia_search_index", toolCallId: "c-1"),
      .toolInputAvailable(toolName: "algolia_search_index", toolCallId: "c-1", input: inputJson),
      .toolOutputAvailable(toolName: "algolia_search_index", toolCallId: "c-1", output: outputJson, preliminary: false),
    ]
    for chunk in chunks { ChunkReducer.apply(chunk, to: &msg) }

    let part = msg.parts.compactMap { p -> ToolUIPart? in
      if case let .tool(t) = p { return t }
      return nil
    }.first
    XCTAssertNotNil(part)
    if case let .outputAvailable(_, output, _) = part?.state {
      XCTAssertEqual(output, outputJson)
    } else {
      XCTFail("expected outputAvailable")
    }
  }

  func testSseExtractionIgnoresKeepalivesAndDoneSentinel() {
    XCTAssertEqual(SSEStreamParser.AsyncIterator.extractJsonPayload(from: "data: {\"type\":\"finish\"}"), "{\"type\":\"finish\"}")
    XCTAssertEqual(SSEStreamParser.AsyncIterator.extractJsonPayload(from: "data: [DONE]"), "[DONE]")
    XCTAssertNil(SSEStreamParser.AsyncIterator.extractJsonPayload(from: "event: ping"))
    XCTAssertNil(SSEStreamParser.AsyncIterator.extractJsonPayload(from: "id: 123"))
  }

  func testEndpointBuildsExpectedUrl() {
    let endpoint = AgentStudioEndpoint(appID: "ABC123", agentID: "shopping-assistant")
    let url = endpoint.completionsURL(stream: true, cache: true)
    XCTAssertEqual(url.absoluteString,
                   "https://ABC123.algolia.net/agent-studio/1/agents/shopping-assistant/completions?compatibilityMode=ai-sdk-5&stream=true")
  }
}

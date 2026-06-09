//
//  ChunkReducerTests.swift
//  InstantSearchAgentTests
//

import XCTest
@testable import InstantSearchAgent

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

  func testToolOutputAvailableWithoutToolNameIsNotDropped() throws {
    // Agent Studio's ai-sdk-5 stream omits `toolName` on `tool-output-available`
    // (the call is already identified by `toolCallId`). Decoding must not drop it.
    let payload = Data(#"{"type":"tool-output-available","toolCallId":"c-1","output":{"hits":[{"objectID":"1","name":"Laptop"}]}}"#.utf8)
    let chunk = try XCTUnwrap(UIMessageChunk.decode(payload: payload))
    guard case let .toolOutputAvailable(name, cid, _, _) = chunk else {
      return XCTFail("expected toolOutputAvailable, got \(chunk)")
    }
    XCTAssertNil(name)
    XCTAssertEqual(cid, "c-1")
  }

  func testToolOutputPreservesNameFromInputStartWhenOutputOmitsIt() {
    var msg = UIMessage<EmptyMetadata>(id: "alg_msg_3", role: .assistant)
    let outputJson = Data(#"{"hits":[{"objectID":"1","name":"Laptop"}]}"#.utf8)
    let chunks: [UIMessageChunk] = [
      .toolInputStart(toolName: "algolia_search_index", toolCallId: "c-1"),
      // `toolName` absent on the wire -> decoded as nil
      .toolOutputAvailable(toolName: nil, toolCallId: "c-1", output: outputJson, preliminary: false),
    ]
    for chunk in chunks { ChunkReducer.apply(chunk, to: &msg) }

    let part = msg.parts.compactMap { p -> ToolUIPart? in
      if case let .tool(t) = p { return t }
      return nil
    }.first
    XCTAssertEqual(part?.toolName, "algolia_search_index")
    if case .outputAvailable = part?.state {} else {
      XCTFail("expected outputAvailable")
    }
  }

  func testToolOutputDeltaAccumulatesAndParses() {
    var msg = UIMessage<EmptyMetadata>(id: "alg_msg_4", role: .assistant)
    let chunks: [UIMessageChunk] = [
      .toolInputStart(toolName: "algolia_display_results", toolCallId: "c-9"),
      .toolOutputDelta(toolCallId: "c-9", toolName: "algolia_display_results", delta: #"{"intro":"curated""#),
      .toolOutputDelta(toolCallId: "c-9", toolName: "algolia_display_results", delta: #","groups":[]}"#),
    ]
    for chunk in chunks { ChunkReducer.apply(chunk, to: &msg) }

    let part = msg.parts.compactMap { p -> ToolUIPart? in
      if case let .tool(t) = p { return t }
      return nil
    }.first
    guard case let .outputAvailable(_, _, preliminary) = part?.state else {
      return XCTFail("expected outputAvailable, got \(String(describing: part?.state))")
    }
    XCTAssertTrue(preliminary)
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

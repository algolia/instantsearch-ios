//
//  SSEStreamParser.swift
//  InstantSearchAgentStudio
//
//  Async-iterator over the AI SDK 5 SSE stream returned by the Agent Studio
//  completions endpoint. Each line is either:
//      data: <json>           // a UIMessageChunk
//      data: [DONE]           // end-of-stream sentinel
//      <empty>                // SSE keep-alive
//      event: ... / id: ...   // ignored
//
//  Mirrors `parseJsonEventStream` in
//  `instantsearch.js/src/lib/ai-lite/stream-parser.ts`.
//

import Foundation

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SSEStreamParser: AsyncSequence, Sendable {
  public typealias Element = UIMessageChunk

  private let lines: URLSession.AsyncBytes.Lines

  public init(bytes: URLSession.AsyncBytes) {
    self.lines = bytes.lines
  }

  public func makeAsyncIterator() -> AsyncIterator {
    AsyncIterator(lineIterator: lines.makeAsyncIterator())
  }

  public struct AsyncIterator: AsyncIteratorProtocol {
    var lineIterator: URLSession.AsyncBytes.Lines.AsyncIterator

    public mutating func next() async throws -> UIMessageChunk? {
      while let line = try await lineIterator.next() {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        if trimmed.isEmpty { continue }

        guard let payload = Self.extractJsonPayload(from: trimmed) else {
          continue
        }
        if payload == "[DONE]" { return nil }

        guard let data = payload.data(using: .utf8) else { continue }

        if let chunk = try? UIMessageChunk.decode(payload: data) {
          return chunk
        }
        // Malformed individual chunks are skipped, matching JS behavior.
      }
      return nil
    }

    static func extractJsonPayload(from line: String) -> String? {
      if line.hasPrefix("data:") {
        return String(line.dropFirst("data:".count)).trimmingCharacters(in: .whitespaces)
      }
      if line.hasPrefix("{") { return line }
      return nil
    }
  }
}

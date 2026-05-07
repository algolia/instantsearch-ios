//
//  ChatStatus.swift
//  InstantSearchAgentStudio
//

import Foundation

/// State of the chat lifecycle, mirroring `ChatStatus` from
/// `instantsearch.js/src/lib/ai-lite/types.ts`.
///
/// - `submitted`: request sent, awaiting first chunk.
/// - `streaming`: chunks are currently being received.
/// - `ready`: response complete (or chat is idle).
/// - `error`: request failed; inspect `ChatStore.error`.
public enum ChatStatus: String, Sendable, Equatable {
  case submitted
  case streaming
  case ready
  case error
}

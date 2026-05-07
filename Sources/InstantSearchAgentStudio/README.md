# InstantSearchAgentStudio

Minimal native client for [Algolia Agent Studio][1]. Mirrors the AI SDK 5 wire
format used by `react-instantsearch`'s `<Chat>` widget — without bundling any
chat UI. Bring-your-own SwiftUI / UIKit views.

## Install (SwiftPM)

```swift
.product(name: "InstantSearchAgentStudio", package: "InstantSearch")
```

The library has no third-party dependencies; it talks to the Agent Studio
endpoint with `URLSession` only.

## Quick start (SwiftUI)

```swift
import SwiftUI
import InstantSearchAgentStudio

@available(iOS 15.0, *)
struct AgentChatView: View {
  @StateObject private var chat = ChatStore(
    transport: AgentStudioTransport(
      appID: "YOUR_APP_ID",
      apiKey: "YOUR_SEARCH_ONLY_API_KEY",
      agentID: "YOUR_AGENT_ID"
    )
  )
  @State private var input: String = ""

  var body: some View {
    VStack {
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 12) {
          ForEach(chat.messages) { message in
            MessageRow(message: message)
          }
          if chat.status == .submitted || chat.status == .streaming {
            ProgressView().padding(.vertical, 4)
          }
        }
        .padding()
      }

      HStack {
        TextField("Ask anything…", text: $input, onCommit: send)
          .textFieldStyle(.roundedBorder)
        Button("Send", action: send)
          .disabled(input.isEmpty || chat.status != .ready)
        if chat.status == .streaming {
          Button("Stop", action: chat.stop)
        }
      }
      .padding(.horizontal)
    }
    .alert("Error", isPresented: .constant(chat.error != nil), actions: {
      Button("OK", action: chat.clearError)
    }, message: {
      Text(String(describing: chat.error ?? .underlying("Unknown")))
    })
  }

  private func send() {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    chat.send(text: trimmed)
    input = ""
  }
}

private struct MessageRow: View {
  let message: UIMessage<EmptyMetadata>
  var body: some View {
    HStack(alignment: .top) {
      Text(message.role == .user ? "🧑" : "🤖")
      VStack(alignment: .leading, spacing: 4) {
        Text(message.plainText).fixedSize(horizontal: false, vertical: true)
        ForEach(toolCalls, id: \.toolCallId) { tool in
          ToolCallChip(part: tool)
        }
      }
    }
  }

  private var toolCalls: [ToolUIPart] {
    message.parts.compactMap { part in
      if case let .tool(t) = part { return t }
      return nil
    }
  }
}

private struct ToolCallChip: View {
  let part: ToolUIPart
  var body: some View {
    HStack(spacing: 4) {
      Image(systemName: "wrench.and.screwdriver")
      Text(part.toolName).font(.caption.monospaced())
      switch part.state {
      case .inputStreaming:    Text("preparing…").font(.caption)
      case .inputAvailable:    Text("running…").font(.caption)
      case .outputAvailable:   Text("done").font(.caption).foregroundColor(.green)
      case .outputError(_, let err): Text(err).font(.caption).foregroundColor(.red)
      }
    }
    .padding(6)
    .background(Color.secondary.opacity(0.1))
    .cornerRadius(6)
  }
}
```

## What's in v0.1

| | |
|---|---|
| `AgentStudioEndpoint` | Builds the `agent-studio/1/agents/{id}/completions?compatibilityMode=ai-sdk-5` URL. |
| `AgentStudioTransport` | `URLSession`-backed POST + SSE response. |
| `SSEStreamParser` | `AsyncSequence` of `UIMessageChunk` from `URLSession.AsyncBytes`. |
| `ChatStore` | `ObservableObject` aggregating chunks into `UIMessage`s, exposing `messages`, `status`, `error`, plus `send`/`regenerate`/`stop`/`clear`. |


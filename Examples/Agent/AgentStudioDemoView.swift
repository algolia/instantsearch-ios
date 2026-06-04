//
//  AgentStudioDemoView.swift
//  Examples
//
//  Showcase for the experimental, standalone `InstantSearchAgent` package.
//
//  Demonstrates the minimal flow: build an `AgentStudioTransport` from
//  credentials, drive a `ChatStore`, and render its observable state in
//  SwiftUI. The agent id is entered at runtime so the demo can run against any
//  published Agent Studio agent without hardcoding one.
//

import InstantSearchAgent
import SwiftUI

@available(iOS 15.0, *)
struct AgentStudioDemoView: View {
  // Public demo credentials shared by the other examples.
  // In a real app pass a SEARCH-ONLY key — never an admin key.
  private static let appID = "latency"
  private static let apiKey = "1f6fd3a6fb973cb08419fe7d288fa4db"

  @State private var agentID: String = ""
  @State private var input: String = ""
  @StateObject private var holder = ChatStoreHolder()

  var body: some View {
    VStack(spacing: 0) {
      TextField("Agent ID (alg_…)", text: $agentID)
        .textFieldStyle(.roundedBorder)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .padding(.horizontal)
        .padding(.top, 8)
        .onChange(of: agentID) { newValue in
          holder.configure(appID: Self.appID,
                           apiKey: Self.apiKey,
                           agentID: newValue.trimmingCharacters(in: .whitespaces))
        }

      if let chat = holder.store {
        ChatView(chat: chat, input: $input, agentID: agentID)
      } else {
        Spacer()
        Text("Enter an Agent ID to start chatting.")
          .foregroundColor(.secondary)
        Spacer()
      }
    }
    .navigationTitle("Agent Studio")
    .navigationBarTitleDisplayMode(.inline)
  }
}

@available(iOS 15.0, *)
private struct ChatView: View {
  @ObservedObject var chat: ChatStore
  @Binding var input: String
  let agentID: String

  var body: some View {
    VStack {
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(chat.messages) { message in
              MessageRow(message: message).id(message.id)
            }
            if chat.status == .submitted || chat.status == .streaming {
              ProgressView().padding(.vertical, 4)
            }
          }
          .padding()
        }
        .onChange(of: chat.messages.count) { _ in
          if let last = chat.messages.last {
            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
          }
        }
      }

      if let error = chat.error {
        Text(String(describing: error))
          .font(.caption)
          .foregroundColor(.red)
          .padding(.horizontal)
      }

      HStack {
        TextField("Ask anything…", text: $input, onCommit: send)
          .textFieldStyle(.roundedBorder)
        Button("Send", action: send)
          .disabled(input.isEmpty || agentID.isEmpty || chat.status != .ready)
        if chat.status == .streaming {
          Button("Stop", action: chat.stop)
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 8)
    }
  }

  private func send() {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty, !agentID.isEmpty else { return }
    chat.send(text: trimmed)
    input = ""
  }
}

@available(iOS 15.0, *)
private struct MessageRow: View {
  let message: UIMessage<EmptyMetadata>

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(message.role == .user ? "You" : "Assistant")
        .font(.caption).bold()
        .foregroundColor(.secondary)
      Text(message.plainText.isEmpty ? "…" : message.plainText)
        .fixedSize(horizontal: false, vertical: true)
      ForEach(toolCalls, id: \.toolCallId) { tool in
        Text("🔧 \(tool.toolName) • \(label(for: tool.state))")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var toolCalls: [ToolUIPart] {
    message.parts.compactMap { part in
      if case let .tool(tool) = part { return tool }
      return nil
    }
  }

  private func label(for state: ToolCallState) -> String {
    switch state {
    case .inputStreaming: return "preparing…"
    case .inputAvailable: return "running…"
    case .outputAvailable: return "done"
    case let .outputError(_, errorText): return "error: \(errorText)"
    }
  }
}

/// Holds the `ChatStore` so it can be rebuilt when the agent id changes while
/// keeping a stable `@StateObject` identity for the screen.
@available(iOS 15.0, *)
@MainActor
private final class ChatStoreHolder: ObservableObject {
  @Published var store: ChatStore?
  private var currentAgentID: String?

  func configure(appID: String, apiKey: String, agentID: String) {
    guard !agentID.isEmpty else {
      store = nil
      currentAgentID = nil
      return
    }
    guard agentID != currentAgentID else { return }
    currentAgentID = agentID
    store?.stop()
    let transport = AgentStudioTransport(appID: appID, apiKey: apiKey, agentID: agentID)
    store = ChatStore(transport: transport)
  }
}

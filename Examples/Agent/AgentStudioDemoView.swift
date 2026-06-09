//
//  AgentStudioDemoView.swift
//  Examples
//
//  Showcase for the experimental, standalone `InstantSearchAgent` package.
//
//  Demonstrates the minimal flow: build an `AgentStudioTransport` from
//  credentials, drive a `ChatStore`, and render its observable state in
//  SwiftUI. It reuses the Agent Studio showcase agent that ships with the
//  InstantSearch web examples, so it works out of the box with no setup.
//

import InstantSearchAgent
import SwiftUI

@available(iOS 15.0, *)
struct AgentStudioDemoView: View {
  // Same Agent Studio showcase config that ships with the InstantSearch web
  // examples (`examples/js/showcase`), so the demo works out of the box.
  // In a real app pass a SEARCH-ONLY key — never an admin key.
  private static let appID = "latency"
  private static let apiKey = "6be0576ff61c053d5f9a3225e2a90f76"
  private static let agentID = "eedef238-5468-470d-bc37-f99fa741bd25"

  @State private var input: String = ""
  @StateObject private var holder = ChatStoreHolder()

  var body: some View {
    VStack(spacing: 0) {
      if let chat = holder.store {
        ChatView(chat: chat, input: $input)
      } else {
        ProgressView()
      }
    }
    .navigationTitle("Agent Studio")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      holder.configure(appID: Self.appID, apiKey: Self.apiKey, agentID: Self.agentID)
    }
  }
}

@available(iOS 15.0, *)
private struct ChatView: View {
  @ObservedObject var chat: ChatStore
  @Binding var input: String

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
          .disabled(input.isEmpty || chat.status != .ready)
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
    guard !trimmed.isEmpty else { return }
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
      if !message.plainText.isEmpty {
        Text(message.plainText)
          .fixedSize(horizontal: false, vertical: true)
      }
      ForEach(toolCalls, id: \.toolCallId) { tool in
        ToolPartView(tool: tool)
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
}

@available(iOS 15.0, *)
private struct ToolPartView: View {
  let tool: ToolUIPart

  var body: some View {
    switch tool.state {
    case let .outputAvailable(_, output, _):
      // Mirrors the web Chat widget: the `algolia_search_index` tool returns
      // `output.hits`, which we render as a product carousel.
      let products = Self.isSearchTool(tool.toolName) ? Self.products(from: output) : []
      if products.isEmpty {
        statusLabel("done")
      } else {
        ProductCarousel(products: products)
      }
    case let .outputError(_, errorText):
      statusLabel("error: \(errorText)")
    case .inputAvailable:
      statusLabel("running…")
    case .inputStreaming:
      statusLabel("preparing…")
    }
  }

  private func statusLabel(_ status: String) -> some View {
    Text("🔧 \(tool.toolName) • \(status)")
      .font(.caption)
      .foregroundColor(.secondary)
  }

  /// The web showcase treats `algolia_search_index` and `algolia_search_index_*`
  /// (MCP) as product search.
  static func isSearchTool(_ name: String) -> Bool {
    name == "algolia_search_index" || name.hasPrefix("algolia_search_index_")
  }

  /// Reads `output.hits[]` from the search tool result, matching the web widget.
  static func products(from output: Data) -> [AgentProduct] {
    guard let root = try? JSONSerialization.jsonObject(with: output) as? [String: Any],
          let hits = root["hits"] as? [[String: Any]] else {
      return []
    }
    return hits.compactMap { hit in
      guard let objectID = hit["objectID"] as? String else { return nil }
      let name = (hit["name"] as? String) ?? (hit["title"] as? String) ?? objectID
      let imageURL = (hit["image"] as? String) ?? (hit["image_url"] as? String) ?? (hit["thumbnailUrl"] as? String)
      let price: String? = {
        if let value = hit["price"] as? Double { return "$\(value)" }
        if let value = hit["price"] as? Int { return "$\(value)" }
        return nil
      }()
      return AgentProduct(objectID: objectID, name: name, imageURL: imageURL.flatMap(URL.init(string:)), price: price)
    }
  }
}

private struct AgentProduct: Identifiable, Equatable {
  let objectID: String
  let name: String
  let imageURL: URL?
  let price: String?

  var id: String { objectID }
}

@available(iOS 15.0, *)
private struct ProductCarousel: View {
  let products: [AgentProduct]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top, spacing: 8) {
        ForEach(products) { ProductCard(product: $0) }
      }
      .padding(.vertical, 8)
    }
  }
}

@available(iOS 15.0, *)
private struct ProductCard: View {
  let product: AgentProduct

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ZStack {
        Color(.secondarySystemBackground)
        if let url = product.imageURL {
          AsyncImage(url: url) { image in
            image.resizable().scaledToFit()
          } placeholder: {
            ProgressView()
          }
        } else {
          Text("🛍️").font(.largeTitle)
        }
      }
      .frame(width: 140, height: 120)
      .clipped()

      VStack(alignment: .leading, spacing: 2) {
        Text(product.name)
          .font(.caption).bold()
          .lineLimit(2)
        if let price = product.price {
          Text(price)
            .font(.caption)
            .foregroundColor(.accentColor)
        }
      }
      .padding(8)
      .frame(width: 140, alignment: .leading)
    }
    .background(Color(.systemBackground))
    .cornerRadius(8)
    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.separator), lineWidth: 0.5))
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

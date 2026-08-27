//
//  CompositionDemoView.swift
//  Examples
//
//  Showcase for `CompositionSearcher`, the searcher targeting the Algolia
//  Composition API (`/1/compositions/{compositionID}/run`).
//
//  A composition is configured per application in the Algolia dashboard, so
//  there is no public demo composition to hardcode here. The screen starts
//  with a small form asking for your application credentials and composition
//  ID, then drives the regular InstantSearch components (search box, stats,
//  infinite hits) through a `CompositionSearcher`.
//

import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

@available(iOS 15.0, *)
struct CompositionDemoView: View {
  @State private var appID: String = ""
  @State private var apiKey: String = ""
  @State private var compositionID: String = ""
  @State private var setupError: String?
  @StateObject private var holder = CompositionControllerHolder()

  var body: some View {
    if let controller = holder.controller {
      CompositionSearchView(controller: controller)
    } else {
      setupForm
    }
  }

  private var setupForm: some View {
    Form {
      Section {
        TextField("Application ID", text: $appID)
          .autocapitalization(.none)
          .disableAutocorrection(true)
        TextField("Search-only API Key", text: $apiKey)
          .autocapitalization(.none)
          .disableAutocorrection(true)
        TextField("Composition ID", text: $compositionID)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      } header: {
        Text("Credentials")
      } footer: {
        Text("Compositions are configured per application in the Algolia dashboard. Enter the credentials of an application with at least one composition.")
      }

      if let setupError {
        Text(setupError)
          .font(.caption)
          .foregroundColor(.red)
      }

      Button("Start searching") {
        do {
          try holder.configure(appID: appID, apiKey: apiKey, compositionID: compositionID)
          setupError = nil
        } catch {
          setupError = String(describing: error)
        }
      }
      .disabled(appID.isEmpty || apiKey.isEmpty || compositionID.isEmpty)
    }
    .navigationTitle("Composition")
    .navigationBarTitleDisplayMode(.inline)
  }
}

@available(iOS 15.0, *)
private struct CompositionSearchView: View {
  let controller: CompositionDemoController

  @ObservedObject var searchBoxController: SearchBoxObservableController
  @ObservedObject var statsController: StatsTextObservableController
  @ObservedObject var hitsController: HitsObservableController<[String: AnyCodable]>
  @State private var isEditing = false

  init(controller: CompositionDemoController) {
    self.controller = controller
    searchBoxController = controller.searchBoxController
    statsController = controller.statsController
    hitsController = controller.hitsController
  }

  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $searchBoxController.query,
                isEditing: $isEditing,
                onSubmit: searchBoxController.submit)
      Text(statsController.stats)
        .fontWeight(.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
      HitsList(hitsController) { hit, _ in
        CompositionHitRow(hit: hit)
        Divider()
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationTitle("Composition")
    .navigationBarTitleDisplayMode(.inline)
  }
}

/// Composition records don't have a fixed schema, so the row displays the
/// most common "title" attributes and falls back to the objectID.
private struct CompositionHitRow: View {
  let hit: [String: AnyCodable]?

  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(title)
        .font(.body)
      if let objectID {
        Text(objectID)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal)
    .padding(.vertical, 5)
  }

  private var objectID: String? {
    hit?["objectID"]?.value as? String
  }

  private var title: String {
    for attribute in ["name", "title", "label"] {
      if let value = hit?[attribute]?.value as? String {
        return value
      }
    }
    return objectID ?? ""
  }
}

final class CompositionDemoController {
  let searcher: CompositionSearcher
  let searchBoxInteractor: SearchBoxInteractor
  let hitsInteractor: HitsInteractor<[String: AnyCodable]>
  let statsInteractor: StatsInteractor

  let searchBoxController: SearchBoxObservableController
  let statsController: StatsTextObservableController
  let hitsController: HitsObservableController<[String: AnyCodable]>

  init(appID: String, apiKey: String, compositionID: String) throws {
    searcher = try CompositionSearcher(appID: appID,
                                       apiKey: apiKey,
                                       compositionID: compositionID)
    searchBoxInteractor = .init()
    hitsInteractor = .init(infiniteScrolling: .on(withOffset: 10),
                           showItemsOnEmptyQuery: true)
    statsInteractor = .init()
    searchBoxController = .init()
    statsController = .init()
    hitsController = .init()

    searchBoxInteractor.connectSearcher(searcher)
    searchBoxInteractor.connectController(searchBoxController)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsController)
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(statsController)

    searcher.search()
  }
}

/// Holds the demo controller built from the credentials entered in the form,
/// keeping a stable `@StateObject` identity for the screen.
private final class CompositionControllerHolder: ObservableObject {
  @Published var controller: CompositionDemoController?

  func configure(appID: String, apiKey: String, compositionID: String) throws {
    controller = try CompositionDemoController(appID: appID,
                                               apiKey: apiKey,
                                               compositionID: compositionID)
  }
}

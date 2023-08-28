//
//  InfiniteList.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import SwiftUI

/// `InfiniteList` is a SwiftUI generic view responsible for displaying a list of paginated data provided by the `InfiniteScrollViewModel` class.
/// It provides an easy way to render items list as well as handling pagination and no results view.
///
/// Usage:
/// ```
/// let viewModel = PaginatedDataViewModel(source: CustomPageSource())
/// let itemsList = InfiniteList(viewModel, itemView: { item in
///   Text(item.title)
/// }, noResults: {
///   Text("No results found")
/// })
/// ```
///
/// - Note: This view is available from iOS 15.0 onwards.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct InfiniteList<ItemView: View, NoResults: View, Item, P: Page<Item>>: View {

  /// An instance of `PaginatedDataViewModel` object.
  @StateObject public var viewModel: PaginatedDataViewModel<P>

  /// A closure that returns a `ItemView` for a given `Source.Item`.
  let itemView: (Item) -> ItemView

  /// A closure that returns a `NoResults` view to display when there are no items.
  let noResults: () -> NoResults

  /// Initializes a new instance of `InfiniteList` with the provided `items`, `itemView` and `noResults` closures.
  ///
  /// - Parameters:
  ///   - viewModel: An instance of `InfiniteScrollViewModel` object.
  ///   - itemView: A closure that returns a `ItemView` for a given `Source.Item`.
  ///   - noResults: A closure that returns a `NoResults` view to display when there are no items.
  public init(_ viewModel: PaginatedDataViewModel<P>,
              @ViewBuilder itemView: @escaping (Item) -> ItemView,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.itemView = itemView
    self.noResults = noResults
  }

  public var body: some View {
    if viewModel.items.isEmpty && !viewModel.hasNext {
      noResults()
        .frame(maxHeight: .infinity)
    } else {
      ScrollView {
        LazyVStack {
          if viewModel.hasPrevious {
            ProgressView()
              .task {
                viewModel.loadPrevious()
              }
          }
          ForEach(0..<viewModel.items.count, id: \.self) { index in
            itemView(viewModel.items[index])
          }
          if viewModel.hasNext {
            ProgressView()
              .task {
                viewModel.loadNext()
              }
          }
        }
      }
    }
  }

}
#endif

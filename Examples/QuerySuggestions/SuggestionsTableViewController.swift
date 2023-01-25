//
//  SuggestionsTableViewController.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import InstantSearch
import UIKit

class SuggestionsTableViewController: UITableViewController, HitsController, SearchBoxController {
  var onQueryChanged: ((String?) -> Void)?
  var onQuerySubmitted: ((String?) -> Void)?

  public var hitsSource: HitsInteractor<QuerySuggestion>?

  let cellID = "сellID"

  override public init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: cellID)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setQuery(_: String?) {
    // not applicable
  }

  override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }

  override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? SearchSuggestionTableViewCell else { return .init() }

    if let suggestion = hitsSource?.hit(atIndex: indexPath.row) {
      cell.setup(with: suggestion)
      cell.didTapTypeAheadButton = {
        self.onQueryChanged?(suggestion.query)
      }
    }

    return cell
  }

  override public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let suggestion = hitsSource?.hit(atIndex: indexPath.row) else { return }
    onQuerySubmitted?(suggestion.query)
  }
}

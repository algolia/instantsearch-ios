//
//  SearchResultsController.swift
//  QuerySuggestionsCategories
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import InstantSearch
import UIKit

extension QuerySuggestionsCategories {

  class SearchResultsController: UITableViewController {

    var didSelectSuggestion: ((String) -> Void)?

    enum Section: Int, CaseIterable {
      case categories
      case suggestions

      var title: String {
        switch self {
        case .categories:
          return "Categories"
        case .suggestions:
          return "Suggestions"
        }
      }

      var cellReuseIdentifier: String {
        switch self {
        case .categories:
          return "categories"
        case .suggestions:
          return "suggestions"
        }
      }

    }

    weak var categoriesInteractor: FacetListInteractor? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = categoriesInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }

    weak var suggestionsInteractor: HitsInteractor<QuerySuggestion>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = suggestionsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: Section.suggestions.cellReuseIdentifier)
      tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: Section.categories.cellReuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(rawValue: section) else { return 0 }
      switch section {
      case .categories:
        return categoriesInteractor?.items.count ?? 0
      case .suggestions:
        return suggestionsInteractor?.numberOfHits() ?? 0
      }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

      let cell: UITableViewCell

      switch section {
      case .categories:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.categories.cellReuseIdentifier, for: indexPath)
        if
          let category = categoriesInteractor?.items[indexPath.row],
          let categoryCell = cell as? CategoryTableViewCell {
            categoryCell.setup(with: category)
        }
      case .suggestions:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.suggestions.cellReuseIdentifier, for: indexPath)
        if
          let suggestion = suggestionsInteractor?.hit(atIndex: indexPath.row),
          let suggestionCell = cell as? SearchSuggestionTableViewCell {
            suggestionCell.setup(with: suggestion)
        }
      }

      return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let section = Section(rawValue: section) else { return nil }
      switch section {
      case .categories where categoriesInteractor?.items.count ?? 0 == 0:
        return nil
      case .suggestions where suggestionsInteractor?.numberOfHits() ?? 0 == 0:
        return nil
      default:
        return section.title
      }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let section = Section(rawValue: indexPath.section) else { return }
      switch section {
      case .suggestions:
        suggestionsInteractor?.hit(atIndex: indexPath.row).flatMap { didSelectSuggestion?($0.query) }

      case .categories:
        // Handle category selection
        break
      }
    }

  }

}

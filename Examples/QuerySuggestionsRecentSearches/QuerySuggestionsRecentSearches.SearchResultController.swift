//
//  SearchResultController.swift
//  QuerySuggestionsRecentSearches
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import InstantSearch
import UIKit

extension QuerySuggestionsAndRecentSearches {

  class SearchResultsController: UITableViewController, HitsController {

    var hitsSource: HitsInteractor<QuerySuggestion>?

    var recentSearches: [String] = ["last search"]

    var onSelection: ((String) -> Void)?

    private let headerTitleFontSize: CGFloat = 15
    private let headerTitleHeight: CGFloat = 28

    enum Section: Int, CaseIterable {
      case recentSearches
      case querySuggestions

      var header: String {
        switch self {
        case .querySuggestions:
          return "Suggestions"
        case .recentSearches:
          return "Recent searches"
        }
      }

      var cellReuseIdentifier: String {
        switch self {
        case .querySuggestions:
          return "suggestion"
        case .recentSearches:
          return "recentSearch"
        }
      }

    }

    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: Section.querySuggestions.cellReuseIdentifier)
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: Section.recentSearches.cellReuseIdentifier)
      tableView.sectionHeaderTopPadding = 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(rawValue: section) else { return 0 }
      switch section {
      case .recentSearches:
        return recentSearches.count
      case .querySuggestions:
        return hitsSource?.numberOfHits() ?? 0
      }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
      let cell: UITableViewCell
      switch section {
      case .recentSearches:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.recentSearches.cellReuseIdentifier, for: indexPath)
        cell.imageView?.image = UIImage(systemName: "clock.arrow.circlepath")
        cell.textLabel?.text = recentSearches[indexPath.row]

      case .querySuggestions:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.querySuggestions.cellReuseIdentifier, for: indexPath)
        if
          let suggestionCell = cell as? SearchSuggestionTableViewCell,
          let suggestion = hitsSource?.hit(atIndex: indexPath.row) {
            suggestionCell.setup(with: suggestion)
        }
      }
      return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let section = Section(rawValue: indexPath.section) else { return }
      switch section {
      case .recentSearches:
        onSelection?(recentSearches[indexPath.row])

      case .querySuggestions:
        hitsSource?.hit(atIndex: indexPath.row).flatMap {
          onSelection?($0.query)
        }
      }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let section = Section(rawValue: section) else { return nil }
      switch section {
      case .recentSearches:
        return recentSearches.isEmpty ? nil : section.header

      case .querySuggestions:
        let isEmpty = hitsSource.flatMap { $0.numberOfHits() == 0 } ?? true
        return isEmpty ? nil : section.header
      }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
      guard let section = Section(rawValue: indexPath.section) else { return .none }
      switch section {
      case .recentSearches:
        return .delete

      case .querySuggestions:
        return .none
      }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      guard let section = Section(rawValue: indexPath.section) else { return }
      switch section {
      case .recentSearches:
        deleteRecentSearch(atIndex: indexPath.row)

      case .querySuggestions:
        break
      }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      guard let section = Section(rawValue: section) else { return 0 }
      switch section {
      case .recentSearches:
        return recentSearches.isEmpty ? 0 : headerTitleHeight

      case .querySuggestions:
        return headerTitleHeight
      }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      guard let section = Section(rawValue: section) else { return nil }
      if case(.recentSearches) = section, !recentSearches.isEmpty {
        let header = SectionHeader(frame: .zero)
        header.label.font = .systemFont(ofSize: headerTitleFontSize, weight: .semibold)
        header.label.text = Section.recentSearches.header
        header.button.addTarget(self, action: #selector(clearRecentSearches), for: .touchUpInside)
        return header
      } else {
        return nil
      }
    }

    private func deleteRecentSearch(atIndex index: Int) {
      recentSearches.remove(at: index)
      tableView.beginUpdates()
      tableView.reloadSections([Section.recentSearches.rawValue], with: .automatic)
      tableView.endUpdates()
    }

    @objc private func clearRecentSearches() {
      recentSearches.removeAll()
      tableView.beginUpdates()
      tableView.reloadSections([Section.recentSearches.rawValue], with: .automatic)
      tableView.endUpdates()
    }

  }

}

private class SectionHeader: UIView {

  let label = UILabel()
  let button = UIButton()

  override init(frame: CGRect) {
    super.init(frame: frame)

    label.textColor = UIColor.secondaryLabel
    label.translatesAutoresizingMaskIntoConstraints = false

    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "trash"), for: .normal)

    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false

    let stackView = UIStackView()
    stackView.distribution = .fill
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: -20)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(separator)
    stackView.addArrangedSubview(button)
    addSubview(stackView)
    stackView.pin(to: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

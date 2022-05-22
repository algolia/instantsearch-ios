//
//  SearchResultsController.swift
//  Examples
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import InstantSearch
import UIKit

extension MultiIndex {

  class SearchResultsController: UITableViewController {

    enum Section: Int, CaseIterable {

      case actors
      case movies

      var title: String {
        switch self {
        case .actors:
          return "Actors"
        case .movies:
          return "Movies"
        }
      }

      var image: UIImage? {
        switch self {
        case .movies:
          return UIImage(systemName: "film")
        case .actors:
          return UIImage(systemName: "person.circle")
        }
      }

      init?(section: Int) {
        self.init(rawValue: section)
      }

      init?(indexPath: IndexPath) {
        self.init(section: indexPath.section)
      }

    }

    let cellReuseIdentifier = "cellID"

    func numberOfHits(in section: Section) -> Int {
      switch section {
      case .actors:
        return actorsHitsInteractor?.numberOfHits() ?? 0
      case .movies:
        return moviesHitsInteractor?.numberOfHits() ?? 0
      }
    }

    func cellLabel(forRowIndex rowIndex: Int, at section: Section) -> NSAttributedString? {
      switch section {
      case .actors:
        return actorsHitsInteractor?.hit(atIndex: rowIndex)?.hightlightedString(forKey: "name").map { highlightedString in
          NSAttributedString(highlightedString: highlightedString, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        }
      case .movies:
        return moviesHitsInteractor?.hit(atIndex: rowIndex)?.hightlightedString(forKey: "title").map { highlightedString in
          NSAttributedString(highlightedString: highlightedString, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        }
      }
    }

    weak var actorsHitsInteractor: HitsInteractor<Hit<Actor>>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = actorsHitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }

    weak var moviesHitsInteractor: HitsInteractor<Hit<Movie>>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = moviesHitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(section: section) else { return 0 }
      return numberOfHits(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
      guard let section = Section(indexPath: indexPath) else { return cell }
      cell.tintColor = .lightGray
      cell.imageView?.image = section.image
      cell.textLabel?.attributedText = cellLabel(forRowIndex: indexPath.row, at: section)
      return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let section = Section(section: section), numberOfHits(in: section) != 0 else { return nil }
      return section.title
    }

    // swiftlint:disable unused_optional_binding
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let section = Section(indexPath: indexPath) else { return }
      switch section {
      case .actors:
        if let _ = actorsHitsInteractor?.hit(atIndex: indexPath.row) {
          // Handle actor selection
        }
      case .movies:
        if let _ = moviesHitsInteractor?.hit(atIndex: indexPath.row) {
          // Handle movie selection
        }
      }
    }

  }

}

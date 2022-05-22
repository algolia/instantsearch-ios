//
//  SearchResultsController.swift
//  CategoriesHits
//
//  Created by Vladislav Fitc on 19/11/2021.
//

import Foundation
import InstantSearch
import UIKit

extension CategoriesHits {

  class SearchResultsController: UITableViewController {

    var didSelectSuggestion: ((String) -> Void)?

    enum Section: Int, CaseIterable {
      case categories
      case hits

      var title: String {
        switch self {
        case .categories:
          return "Categories"
        case .hits:
          return "Products"
        }
      }

      var cellReuseIdentifier: String {
        switch self {
        case .categories:
          return "categories"
        case .hits:
          return "hits"
        }
      }

      init?(section: Int) {
        self.init(rawValue: section)
      }

      init?(indexPath: IndexPath) {
        self.init(section: indexPath.section)
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

    weak var hitsInteractor: HitsInteractor<Hit<Product>>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = hitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: Section.categories.cellReuseIdentifier)
      tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: Section.hits.cellReuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(rawValue: section) else { return 0 }
      switch section {
      case .categories:
        return categoriesInteractor?.items.count ?? 0
      case .hits:
        return hitsInteractor?.numberOfHits() ?? 0
      }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

      let cell: UITableViewCell

      switch section {
      case .categories:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.categories.cellReuseIdentifier, for: indexPath)
        if
          let categoryCell = cell as? CategoryTableViewCell,
          let category = categoriesInteractor?.items[indexPath.row] {
          categoryCell.setup(with: category)
        }
      case .hits:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.hits.cellReuseIdentifier, for: indexPath)
        if
          let productTableViewCell = cell as? ProductTableViewCell,
          let hit = hitsInteractor?.hit(atIndex: indexPath.row) {
          productTableViewCell.setup(with: hit)
        }
      }

      return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let section = Section(rawValue: section) else { return nil }
      switch section {
      case .categories where categoriesInteractor?.items.count ?? 0 == 0:
        return nil
      case .hits where hitsInteractor?.numberOfHits() ?? 0 == 0:
        return nil
      default:
        return section.title
      }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard let section = Section(indexPath: indexPath) else { return 0 }
      switch section {
      case .categories:
        return 44
      case .hits:
        return 100
      }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let section = Section(rawValue: indexPath.section) else { return }
      switch section {
      case .hits:
        // Handle hit selection
        break

      case .categories:
        // Handle category selection
        break
      }
    }

  }

}

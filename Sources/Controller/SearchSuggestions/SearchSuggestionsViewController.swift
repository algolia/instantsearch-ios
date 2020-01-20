//
//  SearchSuggestionsViewController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 20/01/2020.
//

import Foundation
import UIKit
import InstantSearchCore

public class SearchSuggestionsViewController: UITableViewController, HitsController {
  
  public var hitsSource: HitsInteractor<Hit<SearchSuggestion>>?
  
  var didSelect: ((Hit<SearchSuggestion>) -> Void)?
  
  let cellID = "suggestionCellID"
  
  public override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func scrollToTop() {
    tableView.scrollToRow(at: .init(), at: .top, animated: false)
  }
  
  public func reload() {
    tableView.reloadData()
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else { return .init() }
    
    if let hightlightSuggestion = hitsSource?.hit(atIndex: indexPath.row)?.highlightResult {
      switch hightlightSuggestion {
      case .dictionary(let dict):
        if let query = dict["query"] {
          switch query {
          case .value(let theQuery):
            if let textLabel = cell.textLabel {
              textLabel.attributedText = NSAttributedString(highlightedResults: [theQuery],
                                                            separator: NSAttributedString(string: ", "),
                                                            attributes: [.font: UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)])
            }
          default: break
          }

        }
      default: break
      }

    }
    return cell
  }

  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let searchSuggestionHit = hitsSource?.hit(atIndex: indexPath.row) else { return }
    didSelect?(searchSuggestionHit)
  }
  
}

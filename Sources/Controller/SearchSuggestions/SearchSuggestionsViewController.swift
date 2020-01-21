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
  
  public var didSelect: ((Hit<SearchSuggestion>) -> Void)?
  
  public var isHighlightingInverted: Bool = false {
    didSet {
      tableView.reloadData()
    }
  }
  
  let cellID = "suggestionCellID"
  
  public override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func scrollToTop() {
    tableView.scrollToFirstNonEmptySection()
  }
  
  public func reload() {
    tableView.reloadData()
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else { return .init() }
    
    if let hightlightSuggestion = hitsSource?.hit(atIndex: indexPath.row)?.hightlightedString(forKey: "query") {
      if let textLabel = cell.textLabel {
        textLabel.attributedText = NSAttributedString(highlightedString: hightlightSuggestion, inverted: isHighlightingInverted, attributes: [.font: UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)])
      }
    }
    return cell
  }

  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let searchSuggestionHit = hitsSource?.hit(atIndex: indexPath.row) else { return }
    didSelect?(searchSuggestionHit)
  }
  
}

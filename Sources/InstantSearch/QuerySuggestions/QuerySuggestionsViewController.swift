//
//  QuerySuggestionsViewController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 20/01/2020.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
  import UIKit

  public class QuerySuggestionsViewController: UITableViewController, HitsController, SearchBoxController {
    public var onQuerySubmitted: ((String?) -> Void)?
    public var onQueryChanged: ((String?) -> Void)?

    public var hitsSource: HitsInteractor<Hit<QuerySuggestion>>?

    public var didSelect: ((Hit<QuerySuggestion>) -> Void)?

    public var isHighlightingInverted: Bool = false {
      didSet {
        tableView.reloadData()
      }
    }

    let cellID = "suggestionCellID"

    override public init(style: UITableView.Style) {
      super.init(style: style)
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    required init?(coder: NSCoder) {
      super.init(coder: coder)
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    public func scrollToTop() {
      tableView.scrollToFirstNonEmptySection()
    }

    public func reload() {
      tableView.reloadData()
    }

    public func setQuery(_: String?) {
      // external query change doesn't affect
    }

    override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
      return hitsSource?.numberOfHits() ?? 0
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else { return .init() }

      if let hightlightSuggestion = hitsSource?.hit(atIndex: indexPath.row)?.hightlightedString(forKey: "query") {
        if let textLabel = cell.textLabel {
          textLabel.attributedText = NSAttributedString(highlightedString: hightlightSuggestion, inverted: isHighlightingInverted, attributes: [.font: UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)])
        }
      }
      return cell
    }

    override public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let querySuggestionHit = hitsSource?.hit(atIndex: indexPath.row) else { return }
      didSelect?(querySuggestionHit)
      onQuerySubmitted?(querySuggestionHit.object.query)
    }
  }
#endif

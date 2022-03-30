//
//  SearchResultsController.swift
//  QuerySuggestions
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import UIKit
import InstantSearch

extension QuerySuggestions {
  
  class SearchResultsController: UITableViewController, HitsController {
        
    var hitsSource: HitsInteractor<QuerySuggestion>?
    
    var didSelectSuggestion: ((String) -> Void)?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: "suggestion")
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      hitsSource?.numberOfHits() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "suggestion", for: indexPath)
      if
        let suggestionCell = cell as? SearchSuggestionTableViewCell,
        let suggestion = hitsSource?.hit(atIndex: indexPath.row) {
          suggestionCell.setup(with: suggestion)
      }
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      hitsSource?.hit(atIndex: indexPath.row).flatMap {
        didSelectSuggestion?($0.query)
      }
    }
          
  }
  
}

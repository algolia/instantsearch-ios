//
//  ViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import UIKit

class ViewController: UITableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Demo.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)
    if let demo = Demo(rawValue: indexPath.row) {
      cell.textLabel?.text = demo.title
    }
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let demo = Demo(rawValue: indexPath.row) else {
      return
    }
    
    let viewController: UIViewController
    
    switch demo {
    case .querySuggestions:
      viewController = QuerySuggestions.SearchViewController()
    
    case .voiceSearch:
      viewController = VoiceSearch.SearchViewController()
      
    case .multiIndex:
      viewController = MultiIndex.SearchViewController()
      
    case .querySuggestionsAndCategories:
      viewController = QuerySuggestionsAndCategories.SearchViewController()
      
    case .querySuggestionsAndRecentSearches:
      viewController = QuerySuggestionsAndRecentSearches.SearchViewController()
      
    case .querySuggestionsAndHits:
      viewController = QuerySuggestionsAndHits.SearchViewController()
    }
    
    navigationController?.pushViewController(viewController, animated: true)
  }

}


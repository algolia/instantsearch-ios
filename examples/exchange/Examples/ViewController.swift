//
//  ViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import UIKit

enum Guide: Int, CaseIterable {
  
  case voiceSearch
  case querySuggestions
  case gettingStartedUIKit
  case gettingStartedSwiftUI
  
  var title: String {
    switch self {
    case .voiceSearch:
      return "Voice Search"
    case .querySuggestions:
      return "Query Suggestions"
    case .gettingStartedUIKit:
      return "Getting started with UIKit"
    case .gettingStartedSwiftUI:
      return "Getting Started with SwiftUI"
    }
  }
  
  var viewController: UIViewController {
    switch self {
    case .querySuggestions:
      return QuerySuggestionsDemoViewController()
    case .voiceSearch:
      return VoiceInputDemoViewController()
    case .gettingStartedUIKit:
      return GettingStartedGuide.StepSeven.ViewController()
    case .gettingStartedSwiftUI:
      return SwiftUIDemoViewController()
    }
  }
  
}

class ViewController: UITableViewController {
  
  enum Section: Int, CaseIterable {
    case codeExchange
    case guides
    case showcase
    
    var title: String {
      switch self {
      case .codeExchange:
        return "Code Exchange"
      case .guides:
        return "Guides"
      case .showcase:
        return "Showcases"
      }
    }
    
  }
  
  private let cellID = "demoCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Demos"
    navigationItem.largeTitleDisplayMode = .always
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else { return 0 }
    switch section {
    case .codeExchange:
      return CodeExchangeDemo.allCases.count
    case .guides:
      return Guide.allCases.count
    case .showcase:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else { return  .init() }
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    cell.accessoryType = .disclosureIndicator
    switch section {
    case .codeExchange:
      if let demo = CodeExchangeDemo(rawValue: indexPath.row) {
        cell.textLabel?.text = demo.title
      }
    case .guides:
      if let guide = Guide(rawValue: indexPath.row) {
        cell.textLabel?.text = guide.title
      }
    case .showcase:
      break
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Section(rawValue: section)?.title
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else { return }
    
    switch section {
    case .codeExchange:
      guard let demo = CodeExchangeDemo(rawValue: indexPath.row) else {
        return
      }
      navigationController?.pushViewController(demo.viewController, animated: true)
      
    case .guides:
      guard let guide = Guide(rawValue: indexPath.row) else {
        return
      }
      navigationController?.pushViewController(guide.viewController, animated: true)
      
    case .showcase:
      break
    }
    

  }

}


//
//  HitsTableViewControllerDemo.swift
//  Example
//
//  Created by Guy Daher on 13/04/2017.
//
//

import UIKit
import InstantSearch
import InstantSearchCore

class HitsTableViewControllerDemo: HitsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = SearchBarWidget()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        hitsTableView = HitsTableWidget(frame: self.view.bounds)
        hitsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hitTableCell")
        
        self.view.addSubview(hitsTableView)
        InstantSearch.shared.registerAllWidgets(in: self.view)
        InstantSearch.shared.register(widget: searchBar)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = hitsTableView.dequeueReusableCell(withIdentifier: "hitTableCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.textLabel?.highlightedTextColor = .black
        cell.textLabel?.highlightedBackgroundColor = .yellow
        
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        print("hit \(String(describing: hit["name"]!)) has been clicked")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // print("I can also edit height!")
        return 50
    }
}

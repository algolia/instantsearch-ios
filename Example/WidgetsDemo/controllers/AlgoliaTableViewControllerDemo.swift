//
//  AlgoliaTableViewControllerDemo.swift
//  Example
//
//  Created by Guy Daher on 13/04/2017.
//
//

import UIKit
import InstantSearch
// TODO: Should remove that when moved highlight logic in IS
import InstantSearchCore

class AlgoliaTableViewControllerDemo: AlgoliaTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTableView = HitsTableWidget()
        hitsTableView.frame = self.view.frame
        hitsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hitTableCell")
        
        self.view.addSubview(hitsTableView)
        
        AlgoliaSearchManager.instance.instantSearchBinder.addAllWidgets(in: self.view)
        hitsTableView.hitDataSource = self
        hitsTableView.hitDelegate = self
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
        print("ey")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Ey2")
        return 50
    }
}

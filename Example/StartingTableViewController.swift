//
//  StartingTableViewController.swift
//  Example
//
//  Created by Guy Daher on 13/04/2017.
//
//

import UIKit

class StartingTableViewController: UITableViewController {
    
    let features: [(description: String, nibName: String, type: UIViewController.Type)] =
        [   ("Full Demo Project", "", ViewController.self),
            ("Stat Widgets", "StatsView", StatsViewController.self),
            ("Algolia Table View Controller", "AlgoliaTableViewControllerDemo", AlgoliaTableViewControllerDemo.self),
         ]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return features.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "initCell", for: indexPath)
        
        cell.textLabel?.text = features[indexPath.row].description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController!
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerID")
        
        } else {
            let feature = features[indexPath.row]
            viewController = feature.type.init(nibName: feature.nibName, bundle: nil)
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

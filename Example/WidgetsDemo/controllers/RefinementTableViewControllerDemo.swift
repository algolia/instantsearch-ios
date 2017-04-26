//
//  RefinementTableViewControllerDemo.swift
//  Example
//
//  Created by Guy Daher on 25/04/2017.
//
//

import UIKit
import InstantSearch
// TODO: Should remove that when moved highlight logic in IS
import InstantSearchCore

class RefinementTableViewControllerDemo: RefinementTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refinementTableView = RefinementTableWidget()
        refinementTableView.attribute = "category"
        refinementTableView.frame = self.view.frame
        //refinementTableView.register(UITableViewCell.self, forCellReuseIdentifier: "facetCell")
        
        self.view.addSubview(refinementTableView)
        AlgoliaSearchManager.instance.instantSearchBinder.addAllWidgets(in: self.view)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell {
        var cell = refinementTableView.dequeueReusableCell(withIdentifier: "refinementCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "refinementCell")
        }
        
        cell!.textLabel?.text = facet
        cell!.detailTextLabel?.text = String(count)
        cell!.accessoryType = refined ? .checkmark : .none
        
        return cell!
    }
    
    
}

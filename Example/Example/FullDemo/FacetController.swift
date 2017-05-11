//
//  FacetController.swift
//  BasicDemo
//
//  Created by Guy Daher on 23/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore
import InstantSearch

class FacetController: UIViewController, RefinementTableViewDataSource {
    
    var instantSearchBinder: InstantSearchBinder!
    @IBOutlet weak var refinementList: RefinementTableWidget!
    @IBOutlet weak var statLabel: UILabel!
    var statLabelController: LabelStatsController!
    
    var refinementViewController: RefinementViewController!
    
    override func viewDidLoad() {
        refinementViewController = RefinementViewController(table: refinementList)
        refinementList.dataSource = refinementViewController
        refinementList.delegate = refinementViewController
        refinementViewController.tableDataSource = self
        // refinementViewController.tableDelegate = self
        
        instantSearchBinder = InstantSearch.reference
        instantSearchBinder.add(widget: refinementList)
        statLabelController = LabelStatsController(label: statLabel)
        instantSearchBinder.add(widget: statLabelController)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell {
        let cell = refinementList.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        
        cell.textLabel?.text = facet
        cell.detailTextLabel?.text = String(count)
        cell.accessoryType = refined ? .checkmark : .none
        
        return cell
    }
}

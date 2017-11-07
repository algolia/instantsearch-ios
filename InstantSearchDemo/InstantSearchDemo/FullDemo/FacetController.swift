//
//  FacetController.swift
//  BasicDemo
//
//  Created by Guy Daher on 23/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FacetController: UIViewController, RefinementTableViewDataSource {
    
    var instantSearch: InstantSearch!
    @IBOutlet weak var refinementList: RefinementTableWidget!
    @IBOutlet weak var statLabel: UILabel!
    
    var refinementController: RefinementController!
    
    override func viewDidLoad() {
        refinementController = RefinementController(table: refinementList)
        refinementList.dataSource = refinementController
        refinementList.delegate = refinementController
        refinementController.tableDataSource = self
        // refinementController.tableDelegate = self
        
        instantSearch = InstantSearch.shared
        instantSearch.register(widget: refinementList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell {
        let cell = refinementList.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        
        cell.textLabel?.text = facet
        cell.detailTextLabel?.text = String(count)
        cell.accessoryType = refined ? .checkmark : .none
        
        return cell
    }
}

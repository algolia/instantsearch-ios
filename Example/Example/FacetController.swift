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

class FacetController: UIViewController, FacetDataSource {
    
    var instantSearchBinder: InstantSearchBinder!
    @IBOutlet weak var refinementList: RefinementListWidget!
    @IBOutlet weak var statLabel: LabelStatsWidget!
    
    override func viewDidLoad() {
        refinementList.facetDataSource = self
        instantSearchBinder.add(widget: refinementList)
        instantSearchBinder.add(widget: statLabel)
    }
    
    func cellFor(facet: String, count: Int, isRefined: Bool, at indexPath: IndexPath) -> UITableViewCell {
        let cell = refinementList.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        
        cell.textLabel?.text = facet
        cell.detailTextLabel?.text = String(count)
        cell.accessoryType = isRefined ? .checkmark : .none
        
        return cell
    }
}

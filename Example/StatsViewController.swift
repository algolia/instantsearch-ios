//
//  StatsViewController.swift
//  Example
//
//  Created by Guy Daher on 13/04/2017.
//
//

import UIKit
import InstantSearch

class StatsViewController: UIViewController {

    var instantSearchBinder: InstantSearchBinder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instantSearchBinder = AlgoliaSearchManager.instance.instantSearchBinder
        instantSearchBinder.addAllWidgets(in: self.view)
    }
}

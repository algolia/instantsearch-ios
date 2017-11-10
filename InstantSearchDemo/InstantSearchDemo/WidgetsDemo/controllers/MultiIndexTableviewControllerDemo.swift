//
//  MultiIndexTableviewControllerDemo.swift
//  InstantSearchDemo
//
//  Created by Guy Daher on 09/11/2017.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch

class MultiIndexTableviewControllerDemo: UIViewController, HitsTableViewDataSource {
    
    @IBOutlet weak var ikeaTableView: HitsTableWidget!
    @IBOutlet weak var bestbuyTableView: HitsTableWidget!
    @IBOutlet weak var searchBar: SearchBarWidget!
    
    var ikeaHitsController: HitsController!
    var bestbuyHitsController: HitsController!

    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_API_KEY = "afc3dd66dd1293e2e2736a5a51b05c0a"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let indexIds: [IndexId] = [IndexId.init(name: "bestbuy"), IndexId.init(name: "ikea")]
        InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, indexIds: indexIds)
        InstantSearch.shared.registerAllWidgets(in: self.view)
        
        ikeaHitsController = HitsController(table: ikeaTableView)
        ikeaTableView.dataSource = ikeaHitsController
        ikeaTableView.delegate = ikeaHitsController
        ikeaHitsController.tableDataSource = self
        
        bestbuyHitsController = HitsController(table: bestbuyTableView)
        bestbuyTableView.dataSource = bestbuyHitsController
        bestbuyTableView.delegate = bestbuyHitsController
        bestbuyHitsController.tableDataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell: UITableViewCell!
        if tableView == ikeaTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "ikeaCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "bestbuyCell", for: indexPath)
        }
        
        cell.textLabel?.text = hit["name"] as? String
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

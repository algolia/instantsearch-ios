//
//  QuerySuggestionDemo.swift
//  InstantSearchDemo
//
//  Created by Guy Daher on 11/29/17.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class QuerySuggestionDemo: MultiHitsTableViewController {
    
    @IBOutlet weak var tableView: MultiHitsTableWidget!
    @IBOutlet weak var searchBar: SearchBarWidget!
    
    var hitsController: MultiHitsController!

    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_API_KEY = "afc3dd66dd1293e2e2736a5a51b05c0a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searcherIds: [SearcherId] = [SearcherId.init(indexName: "instant_search"), SearcherId.init(indexName: "instantsearch_query_suggestions")]
        InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, searcherIds: searcherIds)
        InstantSearch.shared.registerAllWidgets(in: self.view)
        
        hitsTableView = tableView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell: UITableViewCell!

        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "querySuggestionCell", for: indexPath)
            cell.textLabel?.text = hit["query"] as? String
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "query")?.value
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
            cell.textLabel?.text = hit["name"] as? String
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        if indexPath.section == 0 {
            let query = hit["query"] as! String
            InstantSearch.shared.search(with: query)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        if tableView == self.tableView {
            if section == 1 {
                label.text = "Results"
            }
        }
        
        let view = UIView()
        view.addSubview(label)
        view.backgroundColor = UIColor.gray
        return view
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


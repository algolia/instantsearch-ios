//
//  MultiIndexTableviewControllerDemo.swift
//  InstantSearchDemo
//
//  Created by Guy Daher on 09/11/2017.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class MultiIndexTableViewControllerDemo: HitsTableViewController {
    
    @IBOutlet weak var ikeaTableView: HitsTableWidget!
    @IBOutlet weak var bestbuyTableView: HitsTableWidget!
    @IBOutlet weak var searchBar: SearchBarWidget!
    
    @IBOutlet weak var ikeaPriceSlider: SliderWidget!
    @IBOutlet weak var bestBuyPriceSlider: SliderWidget!
    @IBOutlet weak var ikeaPriceLabel: UILabel!
    @IBOutlet weak var bestbuyPriceLabel: UILabel!

    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_API_KEY = "afc3dd66dd1293e2e2736a5a51b05c0a"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hitsTableViews = [ikeaTableView, bestbuyTableView]
        
        let searcherIds: [SearcherId] = [SearcherId.init(index: "bestbuy"), SearcherId.init(index: "ikea")]
        InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, searcherIds: searcherIds)
        InstantSearch.shared.registerAllWidgets(in: self.view)
        
        ikeaPriceSlider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        bestBuyPriceSlider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        ikeaPriceLabel.text = "Ikea > \(ikeaPriceSlider.value.rounded())$"
        bestbuyPriceLabel.text = "Bestbuy > \(bestBuyPriceSlider.value.rounded())$"
    }
    
    @objc func sliderChanged(sender: UISlider) {
        ikeaPriceLabel.text = "Ikea > \(ikeaPriceSlider.value.rounded())$"
        bestbuyPriceLabel.text = "Bestbuy > \(bestBuyPriceSlider.value.rounded())$"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell: UITableViewCell!
        let salesPrice: String!
        if tableView == ikeaTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "ikeaCell", for: indexPath)
            salesPrice = String(hit["price"] as! Double)
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "bestbuyCell", for: indexPath)
            salesPrice = String(hit["salePrice"] as! Double)
        }
        
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.textLabel?.text = hit["name"] as? String
        cell.detailTextLabel?.text = salesPrice
        
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


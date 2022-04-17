//
//  SearchResultsController.swift
//  VoiceSearch
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import UIKit
import InstantSearch

extension VoiceSearch {
  
  class SearchResultsController: UITableViewController, HitsController {
    
    var hitsSource: HitsInteractor<Hit<Product>>?
    
    let productCellID = "productCellID"
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: productCellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      hitsSource?.numberOfHits() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: productCellID, for: indexPath)
      if
        let productTableViewCell = cell as? ProductTableViewCell,
        let product = hitsSource?.hit(atIndex: indexPath.row) {
          productTableViewCell.setup(with: product)
      }
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      // Handle hit selection
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100
    }
    
  }
  
}

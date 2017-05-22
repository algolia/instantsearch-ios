//
//  Playground.playground
//  InstantSearch
//
//  Copyright © 2016 Algolia. All rights reserved.
//

//: Playground - noun: a place where people can play

import UIKit
import InstantSearch
import InstantSearchCore
import AlgoliaSearch


var str = "Hello, playground"

var sliderWidget = SliderWidget()
sliderWidget.attribute = "salePrice"


var searcher: Searcher!
var searchBar: UISearchBar!

func viewDidLoad() {
    super.viewDidLoad()
    
    let client = Client(appID: "appID", apiKey: "apiKey")
    let index = client.index(withName: "indexName")
    searcher = Searcher(index: index, resultHandler: resultHandler)
    searchBar.delegate = self
}

func resultHandler(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
    print(results?.hits)
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searcher.params.query = searchText
    searcher.search()
}

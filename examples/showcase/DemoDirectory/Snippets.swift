//
//  Snippets.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 22/06/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient


struct A {
  
  let client = SearchClient(appID: "", apiKey: "")

  func mySnippet() {
        
    let index = client.index(withName: "contacts")
    index.search(query: "") { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
    
    var query = Query("s")
    query.attributesToRetrieve = ["firstname", "lastname"]
    query.hitsPerPage = 50
    
    index.search(query: query) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
    
    
  }

  func s() {
    
    let index = client.index(withName: "your_index_name")
    var requestOptions = RequestOptions()
    requestOptions.headers["X-Algolia-UserToken"] = "user123"
    index.search(query: "s",
                 requestOptions: requestOptions) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
//    let requestOptions = RequestOptions()
//    requestOptions.headers["X-Algolia-UserToken"] = "user123"
//    index.search(
//      Query(query: "s"),
//      requestOptions: requestOptions,
//      completionHandler: { (content, error) -> Void in
//        if error == nil {
//            print("Result: \(content!)")
//        }
//      }
//    )

  }
  
  func s10() {
    let index = client.index(withName: "contacts")
    index.search(query: "s") { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }

  }
  
  func a() {
    
    let index = client.index(withName: "your_index_name")
    var requestOptions = RequestOptions()
    requestOptions.headers["X-Algolia-UserToken"] = "user123"
    index.search(
      query: "s",
      requestOptions: requestOptions) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
    
  }
  
  lazy var index = { client.index(withName: "your_index_name") }()
  
  mutating func snippet() {
    
    index.searchForFacetValues(of: "category", matching: "phone") { result in
      // Handle results
    }
    
  }
  
  mutating func sffv() {
    var query = Query()
    query.filters = "brand:Apple"
    index.searchForFacetValues(of: "cateogry",
                               matching: "phone",
                               applicableFor: query) { result in
        // Handle results
    }
  }
  
  mutating func sffv2() {
    var query = Query()
    query.filters = "brand:Apple"
    var requestOptions = RequestOptions()
    requestOptions.headers["X-Algolia-User-ID"] = "user123"
    index.searchForFacetValues(of: "category",
                               matching: "phone",
                               applicableFor: query,
                               requestOptions: requestOptions) { result in
        // Handle results
    }

  }
  
  mutating func ms() {
    
    let queries: [IndexedQuery] = [
      .init(indexName: "categories", query: Query("electronics").set(\.hitsPerPage, to: 3)),
      .init(indexName: "products", query: Query("iPhone").set(\.hitsPerPage, to: 3).set(\.filters, to: "_tags:promotions")),
      .init(indexName: "products", query: Query("Galaxy").set(\.hitsPerPage, to: 10)),
    ]

    client.multipleQueries(queries: queries) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
    
  }
  
  mutating func msro() {
    
    let queries: [IndexedQuery] = [
      .init(indexName: "categories", query: "electronics"),
      .init(indexName: "products", query: "iPhone"),
      .init(indexName: "products", query: "Galaxy"),
    ]
    
    var requestOptions = RequestOptions()
    requestOptions.headers["X-Algolia-UserToken"] = "user123"
    client.multipleQueries(queries: queries,
                           requestOptions: requestOptions) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
    
  }
  
  mutating func browse() {
    var query = Query("") // Empty query will match all records
    query.filters = "i<42"
    index.browse(query: query) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
  }
  
  mutating func browseRO() {
    var requestOptions = RequestOptions()
    requestOptions.headers["X-Algolia-User-ID"] = "user123"
    var query = Query("") // Empty query will match all records
    query.filters = "i<42"
    index.browse(query: query,
                 requestOptions: requestOptions) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
  }
  
  mutating func findObject() {
        
    let predicate: (JSON) -> Bool = { hit in
      return hit["firstname"] == "Jimmie"
    }
    
    index.findObject(matching: predicate) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }

    // With a query
    index.findObject(matching: predicate,
                     for: Query("query string")) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }
    
    // With a query and only in the first page
    index.findObject(matching: predicate,
                     for: Query("query string"),
                     paginate: false) { result in
      if case .success(let response) = result {
        print("Response: \(response)")
      }
    }

    
  }
  


}

